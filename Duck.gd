extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func add_duck(duck):
        duck = duck.instance()
        var spring = DampedSpringJoint2D.new()
        spring.set_name('spring')
        duck.set_name('duck')
        duck.position = Vector2(0, 30)
        self.add_child(duck)
        self.add_child(spring)
        spring.set_node_a('..')
        spring.set_node_b('../duck')
        spring.set_length(30)
        spring.set_stiffness(40)