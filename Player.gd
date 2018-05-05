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

var LEFT_ANALOG_DEADZONE = 0.25

enum STATE {
    Playing,
    Scoring,
    MoveToRespawn,
    Spawning
}

var scoring_timer
var spawning_timer
var boost_wait_timer
var boost_timer
var boosting
var screensize
var DEFAULT_COLLISION_MASK = 1
var DEFAULT_COLLISION_LAYER = 1

func _ready():
    screensize = get_viewport_rect().size

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
        xform.origin.x = -50
        xform.origin.y = -50
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

    if Input.is_action_just_pressed(get_action('duck')):
        add_duck(Duck.instance())


func scoring(delta):
    scoring_timer -= delta

    apply_impulse(Vector2(), Vector2(0, 1).normalized() * 4500 * delta)

    if scoring_timer < 0:
        respawn()


func spawning(delta):
    spawning_timer -= delta

    if spawning_timer > 1.5:
        apply_impulse(Vector2(), Vector2(0.7, 1).normalized() * 3500 * delta)
    elif spawning_timer > 0.3:
        apply_impulse(Vector2(), Vector2(0.2, 1).normalized() * 3500 * delta)
    elif spawning_timer > 0:
        apply_impulse(Vector2(), Vector2(-0.2, -1).normalized() * 500 * delta)
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
    spawning_timer = 2
    state = STATE.MoveToRespawn

func entered_score_zone():
    self.set_collision_mask(0)
    self.set_collision_layer(0)
    scoring_timer = 3.0
    state = STATE.Scoring

var joint = null
func add_child_duck(duck):
    if duck.player == self:
        return 
        
    if !tail_duck: 
        tail_duck = duck
        tail_duck.player = self
            
        joint = PinJoint2D.new()
        joint.set_name('joint')
        joint.set_node_a('..')
        joint.set_node_b(duck.get_path())
        add_child(joint)
    else:
        tail_duck.add_child_duck(duck)
        tail_duck = duck
        tail_duck.player = self


func _on_DuckCaptureArea_body_entered(body):
    if body.has_method('is_duck'):
        add_child_duck(body)
