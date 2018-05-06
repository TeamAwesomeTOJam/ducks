extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var start_pos
var bob_speed
var time = 0.0

func _ready():
    start_pos = position
    bob_speed = rand_range(2, 6)

func _process(delta):
    time += delta * bob_speed
    position = start_pos + Vector2(0, sin(time) * 3.0)
    
