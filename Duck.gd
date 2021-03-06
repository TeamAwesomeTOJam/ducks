extends RigidBody2D

export (PackedScene) var Splash
var state
var scoring_timer
var spawn_destination

var direction
var speed
var override_velocity

var DEFAULT_COLLISION_MASK = 15
var DEFAULT_COLLISION_LAYER = 0
var child
var is_post_game = false
var winning = false

enum STATE {
    Playing,
    Scoring,
    MoveToRespawn,
    Spawning,
    PostGame,
}
var is_winner = false

func _ready():
    direction = Vector2(1, rand_range(-0.2, 0.2)).normalized()
    speed = rand_range(450, 750)
    if is_winner:
        winner()
    else:
        respawn()
    
func winner():
    direction = Vector2(1, 0).normalized()
    speed = 750
    is_winner = true
    respawn()
    

func is_duck():
    pass


func _process(delta):
    if state == STATE.Playing:
        playing(delta)
        z_index = position.y + 7
    elif state == STATE.Spawning:
        spawning(delta)
    elif state == STATE.Scoring:
        scoring(delta)
    elif state == STATE.PostGame:
        post_game(delta)


func _game_ended():
    if state == STATE.Playing:
        state = STATE.PostGame
    is_post_game = true


func _integrate_forces(f_state):
    if state == STATE.MoveToRespawn:
        var xform = f_state.get_transform()
        xform.origin.x = -10
        xform.origin.y = rand_range(150,180)
        f_state.set_transform(xform)
        set_applied_force(Vector2(0,0))

        state = STATE.Spawning


func add_duck(duck, behind):
    if child:
        print("can't add duck already have child")
        return
    child = duck
    var new_behind = - self.linear_velocity
    if new_behind.length() == 0:
        new_behind = behind
    var spring = PinJoint2D.new()
    spring.set_name('joint')
    duck.set_name('duck')
    duck.position = new_behind.normalized() * 30
    self.add_child(duck)
    duck.set_owner(self)
    self.add_child(spring)
    spring.set_node_a('..')
    spring.set_node_b('../duck')


###
# States
###

func playing(delta):
    var impulse_vector = direction * speed
    apply_impulse(Vector2(), impulse_vector * delta)
    $AnimatedSprite.play()

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

    apply_impulse(Vector2(), Vector2(0.45, 1).normalized() * 5000 * delta)

    if scoring_timer < 0:
        self.queue_free()

func post_game(delta):
    var impulse_vector = direction * speed * (10.0 if !is_winner else 1.0)
    apply_impulse(Vector2(), impulse_vector * delta)

###
# State Transitions
###

func respawn():
    self.set_collision_mask(0)
    self.set_collision_layer(0)
    self.linear_velocity = Vector2(0,0)
    state = STATE.MoveToRespawn
    if is_winner:
        spawn_destination = Vector2(862.564941, 587.203247)
    else:
        spawn_destination = Vector2(rand_range(740, 1280), rand_range(320, 1100))
    z_index = spawn_destination.y

func enter_playing_state():
    self.set_collision_mask(DEFAULT_COLLISION_MASK)
    self.set_collision_layer(DEFAULT_COLLISION_LAYER)
    state = STATE.Playing if !is_post_game else STATE.PostGame
    
    var splash = Splash.instance()
    splash.position = Vector2()
    splash.scale = Vector2(0.4, 0.4)
    splash.z_index = position.y + 1
    self.add_child(splash)

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
