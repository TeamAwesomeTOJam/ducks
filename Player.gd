extends RigidBody2D

export (int) var SPEED = 500
export (int) var PLAYER_NUMBER = 0
export (PackedScene) var Duck

var tail_duck = null
var state

var FALL_SPEED = 1500
var LEFT_ANALOG_DEADZONE = 0.25

enum STATE {
    Playing,
    Scoring,
    Spawning
}

var scoring_timer
var spawning_timer

var screensize

func _ready():
    screensize = get_viewport_rect().size
    state = STATE.Playing
    

func get_action(dir):
    return "p" + str(PLAYER_NUMBER) + dir

func _process(delta):
    if state == STATE.Playing:
        playing(delta)
    if state == STATE.Scoring:
        scoring(delta)
    if state == STATE.Spawning:
        spawning(delta)
    
    if Input.is_action_just_pressed(get_action('duck')):
        add_duck(Duck.instance())
    

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
    var digital_velocity = Vector2()
    if Input.is_action_pressed(get_action('right')):
        digital_velocity.x += 1
    if Input.is_action_pressed(get_action('left')):
        digital_velocity.x -= 1
    if Input.is_action_pressed(get_action('down')):
        digital_velocity.y += 1
    if Input.is_action_pressed(get_action('up')):
        digital_velocity.y -= 1
    
    var analog_velocity = Vector2(
        Input.get_joy_axis(PLAYER_NUMBER, JOY_AXIS_0), 
        Input.get_joy_axis(PLAYER_NUMBER, JOY_AXIS_1))

    var velocity = analog_velocity if analog_velocity.length() > LEFT_ANALOG_DEADZONE else digital_velocity
    
    if velocity.length() > 0:
        velocity = velocity.normalized() * SPEED
    else:
        velocity = - linear_velocity.normalized() * SPEED
    
    #position += velocity * delta
    apply_impulse(Vector2(), velocity * delta)
    

func scoring(delta):
    apply_impulse(Vector2(), Vector2(0, 1).normalized() * FALL_SPEED * 5 * delta)
    scoring_timer -= delta
    if scoring_timer < 0:
        respawn()
        
        
func spawning(delta):
    apply_impulse(Vector2(), Vector2(0.5, 1).normalized() * FALL_SPEED * delta)
    
    spawning_timer -= delta
    if(spawning_timer < 0):
        self.linear_velocity = Vector2(0,0)
        state = STATE.Playing
        
###
# State Entry Methods
###

func respawn():
    # Set player position to top of the waterfall
    self.position = Vector2(-50,-50)
    self.linear_velocity = Vector2(0,0)
    spawning_timer = 1
    state = STATE.Spawning


func entered_score_zone():
    state = STATE.Scoring
    scoring_timer = 3
