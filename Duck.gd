extends RigidBody2D

var joint = null
var player = null
var prev = null
var next = null


var state
var spawning_timer
var spawn_destination

var DEFAULT_COLLISION_MASK = 15
var DEFAULT_COLLISION_LAYER = 15

enum STATE {
    Playing,
    MoveToRespawn,
    Spawning
}

func _ready():
    respawn()


func is_duck():
    pass


func join(to):
    if self.joint:
        self.joint.free()
        
    self.joint = PinJoint2D.new()
    self.joint.set_name('joint')
    self.joint.set_node_a(to.get_path())
    self.joint.set_node_b(self.get_path())
    self.add_child(self.joint)
    

func _process(delta):
    if state == STATE.Playing:
        playing(delta)
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


###
# States
###

func playing(delta):
    pass

func spawning(delta):
    spawning_timer -= delta

    #if spawning_timer > 0:
    #    print(spawning_timer)
    #    apply_impulse(Vector2(), Vector2(0.7, 1).normalized() * 10000 * delta)
    if self.position.x < spawn_destination.x - 300:
        var vector = Vector2(1, 0.2).normalized()
        self.apply_impulse(Vector2(), vector * 20000 * delta)
    elif self.position.y < spawn_destination.y:
        var vector = (spawn_destination - self.position).normalized()
        self.apply_impulse(Vector2(), vector * 10000 * delta)

    else:
        self.linear_velocity = Vector2(0,0)
        enter_playing_state()

###
# State Transitions
###

func respawn():
    self.set_collision_mask(0)
    self.set_collision_layer(0)
    self.linear_velocity = Vector2(0,0)
    spawning_timer = 1
    state = STATE.MoveToRespawn
    spawn_destination = Vector2(rand_range(50, 1200), rand_range(50, 1200))
    print(spawn_destination)

func enter_playing_state():
    self.set_collision_mask(DEFAULT_COLLISION_MASK)
    self.set_collision_layer(DEFAULT_COLLISION_LAYER)
    state = STATE.Playing
