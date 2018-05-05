extends Node


var game_handle_time = null
var time_remaining = 0.0

var MAX_PLAYERS = 4
var MAX_TIME_PRE_GAME = 5.0
var MAX_TIME_GAME = 10.0

enum STATE {
    idle,
    pre_game,
    game,
}

var IDLE = 'idle'
var PRE_GAME = 'pre_game'
var GAME = 'game'

var state = null
var number_of_active_players = 0


func pre_game():
    $HUD.pre_game(number_of_active_players, MAX_TIME_PRE_GAME)
    update_state(STATE.pre_game)


func start_game():
    $HUD.start_game( MAX_TIME_GAME)
    update_state(STATE.game)


func end_game():
    $HUD.end_game()
    update_state(STATE.idle)


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
        
    state = _state


func update_time(delta):
    if time_remaining > 0.0:
        time_remaining = max(0.0, time_remaining - delta)
        
        if time_remaining == 0.0:
            if state == STATE.pre_game:
                start_game()
            elif state == STATE.game:
                end_game()
    

func _ready():
    update_state(STATE.idle)


func _process(delta):
    update_time(delta)
    update_hud()
    
    # TODO: REMOVE THIS AT SOME POINT, OR DON'T I'M NOT THE BOSS OF YOU.
    if state == STATE.idle && Input.is_action_pressed('ui_up'):
        pre_game()


func _on_ScoringZone_body_entered(body):
    if(body.has_method('entered_score_zone')):
        body.entered_score_zone()
