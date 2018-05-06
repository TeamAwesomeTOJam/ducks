extends Node

signal game_ended

export (PackedScene) var Player
export (PackedScene) var Duck

var game_handle_time = null
var time_remaining = 0.0
var spawn_timer

var MAX_PLAYERS = 4
var MAX_TIME_PRE_GAME = 3.0
var MAX_TIME_GAME = 60.0

enum STATE {
    idle,
    pre_game,
    game,
    post_game,
}

var state = null
var number_of_active_players = 4


func pre_game():
    $HUD.pre_game(number_of_active_players, MAX_TIME_PRE_GAME)
    update_state(STATE.pre_game)


func start_game():
    $HUD.start_game(MAX_TIME_GAME)
    update_state(STATE.game)


func end_game():
    $HUD.end_game()
    update_state(STATE.post_game)
    
#    emit_signal('game_ended')


func update_hud():
    if state == STATE.pre_game:
        $HUD.update_time_pre_game(time_remaining)
    elif state == STATE.game:
        $HUD.update_time_game(time_remaining)


func update_state(_state):
    if _state == STATE.idle:
        pass
    elif _state == STATE.pre_game:
        time_remaining = MAX_TIME_PRE_GAME
    elif _state == STATE.game:
        time_remaining = MAX_TIME_GAME
        spawn_timer = 0
        
    state = _state


func update_time(delta):
    if time_remaining > 0.0:
        time_remaining = max(0.0, time_remaining - delta)
        
        if time_remaining == 0.0:
            if state == STATE.pre_game:
                start_game()
            elif state == STATE.game:
                end_game()
    
func spawn_duck():
    var duck = Duck.instance()
    duck.set_name('duck')
    
    duck.position = Vector2(-500, -500)
    
    self.add_child(duck)
    duck.set_owner(self)
    
    self.connect('game_ended', duck, '_game_ended')
    

func _ready():
    update_state(STATE.idle)
    $Background.play()
    randomize()


func _process(delta):
    update_time(delta)
    update_hud()
    
    for i in range(0, 3):
        var credits_pressed = Input.is_joy_button_pressed(i, JOY_START) and Input.is_joy_button_pressed(i, JOY_SELECT)
        if credits_pressed:
            go_to_credits() 
    
    # TODO: REMOVE THIS AT SOME POINT, OR DON'T I'M NOT THE BOSS OF YOU.
    if state == STATE.idle && Input.is_action_pressed('ui_up'):
        pre_game()
        
    if Input.is_action_just_pressed('p0duck'):
        spawn_duck()
        
    if state == STATE.game:
        game(delta)
    
func go_to_credits():
    get_tree().change_scene("res://Credits.tscn")    

func game(delta):
    spawn_timer += delta
    if time_remaining > 10:
        if spawn_timer > 1:
            spawn_duck()
            spawn_timer -= 1
    elif time_remaining > 0:
        if spawn_timer > 0.5:
            spawn_duck()
            spawn_timer -= 0.5

func _on_ScoringArea_body_entered(body):
    if(body.has_method('entered_score_zone')):
        body.entered_score_zone()
