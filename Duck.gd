extends RigidBody2D


var state
var scoring_timer
var spawn_destination

var direction
var speed

var DEFAULT_COLLISION_MASK = 15
var DEFAULT_COLLISION_LAYER = 15

enum STATE {
    Playing,
    Scoring,
    MoveToRespawn,
    Spawning
}

func _ready():
    direction = Vector2(1, rand_range(-0.2, 0.2)).normalized()
    speed = rand_range(450, 750)
    respawn()


func is_duck():
    pass
    

func _process(delta):
    if state == STATE.Playing:
        playing(delta)
    elif state == STATE.Spawning:
        spawning(delta)
    elif state == STATE.Scoring:
        scoring(delta)
        
    z_index = position.y


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
    var impulse_vector = direction * speed
    apply_impulse(Vector2(), impulse_vector * delta)

func spawning(delta):
    if self.position.x < spawn_destination.x - 300:
        var vector = Vector2(1, 0.05).normalized()
        self.apply_impulse(Vector2(), vector * 20000 * delta)
    elif self.position.y < spawn_destination.y:
        var vector = (spawn_destination - self.position).normalized()
        self.apply_impulse(Vector2(), vector * 10000 * delta)

    else:
        self.linear_velocity = Vector2(0,0)
        enter_playing_state()
        
func scoring(delta):
    scoring_timer -= delta

    apply_impulse(Vector2(), Vector2(0.55, 1).normalized() * 5000 * delta)

    if scoring_timer < 0:
        self.queue_free()

###
# State Transitions
###

func respawn():
    self.set_collision_mask(0)
    self.set_collision_layer(0)
    self.linear_velocity = Vector2(0,0)
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

func entered_score_zone():
    # TODO: IF UNOWNED
    self.set_collision_mask(0)
    self.set_collision_layer(0)
    scoring_timer = 3.0
    state = STATE.Scoring

func _on_Duck_body_entered(body):
    pass
