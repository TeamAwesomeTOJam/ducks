extends RigidBody2D

export (int) var SPEED = 20000
export (int) var MAX_SPEED = 500
export (int) var PLAYER_NUMBER = 0
export (float) var BOOST_FACTOR = 2
export (PackedScene) var Duck
export (float) var BOOST_WAIT_TIME = 3
export (float) var BOOST_TIME = 0.2
export (PackedScene) var Splash

var collecting

var child
var state
var wait = false

var LEFT_ANALOG_DEADZONE = 0.25

enum STATE {
    Playing,
    Scoring,
    MoveToRespawn,
    Spawning
    PostGame,
}

var scoring_timer
var spawn_destination
var boost_wait_timer
var boost_timer
var boosting
var screensize
var DEFAULT_COLLISION_MASK
var DEFAULT_COLLISION_LAYER
var CAPTURE_COLLISION_MASK
var CAPTURE_COLLISION_LAYER
var direction
var speed 
var is_post_game = false
var my_score

var ducks_to_add = 0

func _ready():
    my_score = 0
    direction = Vector2(1, rand_range(-0.2, 0.2)).normalized()
    speed = rand_range(450, 750)
    screensize = get_viewport_rect().size
    DEFAULT_COLLISION_LAYER = 1 << PLAYER_NUMBER
    DEFAULT_COLLISION_MASK = 15 ^ DEFAULT_COLLISION_LAYER
    CAPTURE_COLLISION_MASK = 15
    CAPTURE_COLLISION_LAYER = 15
    $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_right"
    
    get_parent().connect('game_ended', self, '_game_ended')

    enter_playing_state()
    
func _game_ended():
    if state == STATE.Playing:
        state = STATE.PostGame
    is_post_game = true

func get_action(action):
    return "p" + str(PLAYER_NUMBER) + action

func _process(delta):
    collecting = false
    if ducks_to_add > 0:
        add_duck()
        ducks_to_add -= 1
    if state == STATE.Playing:
        playing(delta)
    elif state == STATE.Scoring:
        scoring(delta)
    elif state == STATE.Spawning:
        spawning(delta)
    elif state == STATE.PostGame:
        post_game(delta)
        
    z_index = position.y

func _integrate_forces(f_state):
    if state == STATE.MoveToRespawn:
        var xform = f_state.get_transform()
        xform.origin.x = -10
        xform.origin.y = rand_range(150,180)
        f_state.set_transform(xform)
        set_applied_force(Vector2(0,0))

        state = STATE.Spawning

func add_duck():
    var duck = Duck.instance()
    duck.player = self
    duck.set_collision_mask(DEFAULT_COLLISION_MASK)
    #duck.set_collision_layer(DEFAULT_COLLISION_LAYER)
    var behind = - self.linear_velocity
    if behind.length() == 0:
        behind = Vector2(0,-1)
    if not child:
        child = duck
        var spring = PinJoint2D.new()
        spring.set_name('joint')
        duck.set_name('duck')
        duck.position = behind.normalized() * 50
        self.add_child(duck)
        duck.set_owner(self)
        self.add_child(spring)
        spring.set_node_a('..')
        spring.set_node_b('../duck')
        child = duck
        duck.parent = self
        #spring.set_length(50)
        #spring.set_stiffness(40)
        #spring.set_damping(1)
        #spring.set_rest_length(0)
    else:
        child.add_duck(duck, behind)

###
# STATE METHODS
###
func playing(delta):
    var digital_impulse_vector = Vector2()
    if Input.is_action_pressed(get_action('right')):
        digital_impulse_vector.x += 1
    if Input.is_action_pressed(get_action('left')):
        digital_impulse_vector.x -= 1
    if Input.is_action_pressed(get_action('down')):
        digital_impulse_vector.y += 1
    if Input.is_action_pressed(get_action('up')):
        digital_impulse_vector.y -= 1

    var analog_impulse_vector = Vector2(
        Input.get_joy_axis(PLAYER_NUMBER, JOY_AXIS_0),
        Input.get_joy_axis(PLAYER_NUMBER, JOY_AXIS_1))

    self.boost_timer = max(self.boost_timer - delta, 0)
    self.boost_wait_timer = max(self.boost_wait_timer - delta, 0)
    if self.boost_timer == 0:
        boosting = false

    var boost_pressed = Input.is_joy_button_pressed(PLAYER_NUMBER, JOY_XBOX_A) or Input.is_action_just_pressed(get_action('boost'))

    if  boost_pressed and self.boost_wait_timer == 0:
        self.boosting = true
        self.boost_timer = BOOST_TIME
        self.boost_wait_timer = BOOST_WAIT_TIME

    var impulse_vector = analog_impulse_vector if analog_impulse_vector.length() > LEFT_ANALOG_DEADZONE else digital_impulse_vector

    var max_speed = MAX_SPEED
    if impulse_vector.length() > 0:
        impulse_vector = impulse_vector.normalized() * SPEED
        if self.boosting:
            impulse_vector *= BOOST_FACTOR
            max_speed *= BOOST_FACTOR
    #else:
    #    impulse_vector = - linear_velocity.normalized() * SPEED

    apply_impulse(Vector2(), impulse_vector * delta)

    if get_linear_velocity().length() > max_speed + 10:
        var new_speed = get_linear_velocity().normalized()
        new_speed *= max_speed
        set_linear_velocity(new_speed)
        
    # Animation
    if impulse_vector.x > 0 and abs(impulse_vector.x) > abs(impulse_vector.y):
        $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_right"
    elif impulse_vector.x < 0 and abs(impulse_vector.x) > abs(impulse_vector.y):
        $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_left"
    elif impulse_vector.y > 0 and abs(impulse_vector.y) > abs(impulse_vector.x):
        $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_down"
    elif impulse_vector.y < 0 and abs(impulse_vector.y) > abs(impulse_vector.x):
        $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_up"


func scoring(delta):
    scoring_timer -= delta

    set_linear_velocity(Vector2(0.45, 1).normalized() * 1000)

    if scoring_timer < 0:
        add_score()
        respawn()


func spawning(delta):
    if wait:  # Terrible hack because we need to wait a frame (too many game loops)
        wait = false
        return
    
    if self.position.x < spawn_destination.x:
        var vector = Vector2(1, 0.05).normalized()
        self.set_linear_velocity(vector * 900)
    elif self.position.y < spawn_destination.y:
        var vector = (spawn_destination - self.position).normalized()
        self.set_linear_velocity(vector * 1200)
    else:
        self.linear_velocity = Vector2(0,0)
        enter_playing_state()
        
func post_game(delta):
    var impulse_vector = direction * speed * 10.0
    apply_impulse(Vector2(), impulse_vector * delta)

###
# State Entry Methods
###

func enter_playing_state():
    self.set_collision_mask(DEFAULT_COLLISION_MASK)
    self.set_collision_layer(DEFAULT_COLLISION_LAYER)
    $DuckCaptureArea.set_collision_mask(CAPTURE_COLLISION_MASK)
    $DuckCaptureArea.set_collision_layer(CAPTURE_COLLISION_LAYER)
    self.boost_timer = 0
    self.boost_wait_timer = 0
    self.boosting = false
    state = STATE.Playing if !is_post_game else STATE.PostGame
    
    var splash = Splash.instance()
    splash.position = Vector2()
    splash.z_index = position.y + 1
    self.add_child(splash)

func respawn():
    if is_post_game:
        return
    
    self.linear_velocity = Vector2(0,0)
    state = STATE.MoveToRespawn
    wait = true
    spawn_destination = Vector2(rand_range(740, 1280), rand_range(320, 1100))
    z_index = spawn_destination.y

func entered_score_zone():
    self.set_collision_mask(0)
    self.set_collision_layer(0)
    $DuckCaptureArea.set_collision_mask(0)
    $DuckCaptureArea.set_collision_layer(0)
    scoring_timer = 5.0
    state = STATE.Scoring

func add_score():
    if child:
        my_score += child.count()
        child.kill_me()
        
        get_parent().get_node("HUD").update_player_score(PLAYER_NUMBER, my_score)

func _on_DuckCaptureArea_body_entered(body):
    if not collecting:
        collecting = true
        if body.has_method('is_duck'):
            body.queue_free()
            ducks_to_add += 1
        if body.has_method('is_follow_duck'):
            if body.player != self:
                var count = body.count()
                body.kill_me()
                ducks_to_add += count
    