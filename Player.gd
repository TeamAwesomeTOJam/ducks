extends RigidBody2D

export (int) var SPEED = 20000
export (int) var MAX_SPEED = 500
export (int) var PLAYER_NUMBER = 0
export (float) var BOOST_FACTOR = 2
export (PackedScene) var Duck
export (float) var BOOST_WAIT_TIME = 3
export (float) var BOOST_TIME = 0.2

var tail_duck = null
var state
var wait = false

var LEFT_ANALOG_DEADZONE = 0.25

enum STATE {
    Playing,
    Scoring,
    MoveToRespawn,
    Spawning
}

var scoring_timer
var spawn_destination
var boost_wait_timer
var boost_timer
var boosting
var screensize
var DEFAULT_COLLISION_MASK
var DEFAULT_COLLISION_LAYER

func _ready():
    screensize = get_viewport_rect().size
    DEFAULT_COLLISION_LAYER = 1 << PLAYER_NUMBER
    DEFAULT_COLLISION_MASK = 15 ^ DEFAULT_COLLISION_LAYER

    enter_playing_state()

func get_action(action):
    return "p" + str(PLAYER_NUMBER) + action

func _process(delta):
    if state == STATE.Playing:
        playing(delta)
    elif state == STATE.Scoring:
        scoring(delta)
    elif state == STATE.Spawning:
        spawning(delta)

func _integrate_forces(f_state):
    if state == STATE.MoveToRespawn:
        var xform = f_state.get_transform()
        xform.origin.x = -10
        xform.origin.y = rand_range(150,180)
        f_state.set_transform(xform)
        set_applied_force(Vector2(0,0))

        state = STATE.Spawning

func add_duck(duck):
    if not tail_duck:
        tail_duck = duck
        var spring = PinJoint2D.new()
        spring.set_name('spring')
        duck.set_name('duck')
        duck.position = Vector2(0,50)
        self.add_child(duck)
        duck.set_owner(self)
        self.add_child(spring)
        spring.set_node_a('..')
        spring.set_node_b('../duck')
        #spring.set_length(50)
        #spring.set_stiffness(40)
        #spring.set_damping(1)
        #spring.set_rest_length(0)
    else:
        tail_duck.add_duck(duck)
        tail_duck = duck

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

    if Input.is_action_just_pressed(get_action('boost')) and self.boost_wait_timer == 0:
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
    if impulse_vector.x > 0 and impulse_vector.x > impulse_vector.y:
        $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_right"
    elif impulse_vector.x < 0 and impulse_vector.x < impulse_vector.y:
        $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_left"
    elif impulse_vector.y > 0 and impulse_vector.y > impulse_vector.x:
        $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_down"
    elif impulse_vector.y < 0 and impulse_vector.y < impulse_vector.x:
        $AnimatedSprite.animation = "p" + str(PLAYER_NUMBER) + "_up"

    #if Input.is_action_just_pressed(get_action('duck')):
    #    add_duck(Duck.instance())


func scoring(delta):
    scoring_timer -= delta

    apply_impulse(Vector2(), Vector2(0, 1).normalized() * 4500 * delta)

    if scoring_timer < 0:
        respawn()


#func spawning(delta):
#    spawning_timer -= delta
#
#    if spawning_timer > 1.5:
#        apply_impulse(Vector2(), Vector2(0.7, 1).normalized() * 3500 * delta)
#    elif spawning_timer > 0.3:
#        apply_impulse(Vector2(), Vector2(0.2, 1).normalized() * 3500 * delta)
#    elif spawning_timer > 0:
#        apply_impulse(Vector2(), Vector2(-0.2, -1).normalized() * 500 * delta)
#    else:
#        self.linear_velocity = Vector2(0,0)
#        enter_playing_state()

func spawning(delta):
    if wait:  # Terrible hack because we need to wait a frame (too many game loops)
        wait = false
        return
    
    if self.position.x < spawn_destination.x - 300:
        var vector = Vector2(1, 0.05).normalized()
        self.apply_impulse(Vector2(), vector * 4500 * delta)
    elif self.position.y < spawn_destination.y:
        var vector = (spawn_destination - self.position).normalized()
        self.apply_impulse(Vector2(), vector * 2500 * delta)
    else:
        self.linear_velocity = Vector2(0,0)
        enter_playing_state()

###
# State Entry Methods
###

func enter_playing_state():
    self.set_collision_mask(DEFAULT_COLLISION_MASK)
    self.set_collision_layer(DEFAULT_COLLISION_LAYER)
    self.boost_timer = 0
    self.boost_wait_timer = 0
    self.boosting = false
    state = STATE.Playing

func respawn():
    self.linear_velocity = Vector2(0,0)
    state = STATE.MoveToRespawn
    wait = true
    spawn_destination = Vector2(rand_range(740, 1280), rand_range(320, 1100))

func entered_score_zone():
    self.set_collision_mask(0)
    self.set_collision_layer(0)
    scoring_timer = 3.0
    state = STATE.Scoring


func _on_DuckCaptureArea_body_entered(body):
    if body.has_method('is_duck'):
        handle_duck_collision(body)
#        body.set_collision_stuff(DEFAULT_COLLISION_MASK, DEFAULT_COLLISION_LAYER)

func update_duck_for_current_player(duck):
    duck.player = self
    self.set_collision_mask(DEFAULT_COLLISION_MASK)
    self.set_collision_layer(DEFAULT_COLLISION_LAYER)
    
    
func split_at_node(node):
    $LinkedList.split_at_node(node)
    

func handle_duck_collision(duck):
    if duck.player == self:
        return
    
    if duck.player != null:
        duck.player.split_at_node(duck)
        
    var to = self
    if $LinkedList.tail != null:
        to = $LinkedList.tail 

    $LinkedList.add_nodes_tail(duck)

    var _node_iter = $LinkedList.head
    while _node_iter:
        update_duck_for_current_player(_node_iter)
        _node_iter = _node_iter.next
    
    duck.join(to)
    