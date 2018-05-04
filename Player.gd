extends RigidBody2D

export (int) var SPEED = 500
export (int) var PLAYER_NUMBER = 0

var LEFT_ANALOG_DEADZONE = 0.25

var screensize

func _ready():
    screensize = get_viewport_rect().size

func get_action(dir):
    return "p" + str(PLAYER_NUMBER) + dir

func _process(delta):
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
