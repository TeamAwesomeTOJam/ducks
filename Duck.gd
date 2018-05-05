extends RigidBody2D

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
    

func _process(delta):
    if state == STATE.Playing:
        playing(delta)
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
        var vector = Vector2(1, 0.05).normalized()
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
    spawn_destination = Vector2(rand_range(740, 1280), rand_range(320, 1100))

func enter_playing_state():
    self.set_collision_mask(DEFAULT_COLLISION_MASK)
    self.set_collision_layer(DEFAULT_COLLISION_LAYER)
    state = STATE.Playing

func set_collision_stuff(mask, layer):
    self.set_collision_mask(mask)
    self.set_collision_layer(layer)
    if self.child:
        self.child.set_collision_stuff(mask, layer)

func _on_Duck_body_entered(body):
    pass
