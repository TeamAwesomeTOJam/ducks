extends RigidBody2D

var player = null

var parent = null
var child = null
var joint = null

func _ready():
    pass
    
func is_duck():
    pass
    

func get_tail():
    var tail = self
    while tail.child != null:
        tail = tail.child
    return tail


func add_child_duck(_child): 
    if child: 
        return false
    
    joint = PinJoint2D.new()
    joint.set_name('joint')
    joint.set_node_a('..')
    joint.set_node_b(_child.get_path())
    add_child(joint)
    
    _child.parent = self
    child = _child
    
    return true
    

func remove_child_duck():
    if !child:
        return
        
    joint.free()
    
    var _child = child
    _child.parent = null
    child = null
    
    return _child


func _on_Duck_body_entered(body):
    body
    
func _process(delta):
    pass
