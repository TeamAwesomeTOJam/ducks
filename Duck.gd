extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func add_duck(duck):
        var spring = PinJoint2D.new()
        spring.set_name('spring')
        duck.set_name('duck')
        duck.position = Vector2(0, 30)
        self.add_child(duck)
        duck.set_owner(self)
        self.add_child(spring)
        spring.set_node_a('..')
        spring.set_node_b('../duck')
        #spring.set_length(30)
        #spring.set_stiffness(40)
        #spring.set_damping(1)
        #spring.set_rest_length(0)