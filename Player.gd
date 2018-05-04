extends RigidBody2D

export (int) var SPEED = 500
export (int) var PLAYER_NUMBER = 0

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func get_action(dir):
    return "p" + str(PLAYER_NUMBER) + dir

func _process(delta):
    var velocity = Vector2()
    if Input.is_action_pressed(get_action('right')):
        velocity.x += 1
    if Input.is_action_pressed(get_action('left')):
        velocity.x -= 1
    if Input.is_action_pressed(get_action('down')):
        velocity.y += 1
    if Input.is_action_pressed(get_action('up')):
        velocity.y -= 1
    
    if velocity.length() > 0:
        velocity = velocity.normalized() * SPEED
    else:
        velocity = - linear_velocity.normalized() * SPEED
    
    #position += velocity * delta
    apply_impulse(Vector2(), velocity * delta)
