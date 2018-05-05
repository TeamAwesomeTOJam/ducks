extends Node


var game_handle_time = null
var time_remaining = 0.0

var MAX_PLAYERS = 4
var MAX_TIME_PRE_GAME = 5.0
var MAX_TIME_GAME = 10.0


var IDLE = 'idle'
var PRE_GAME = 'pre_game'
var GAME = 'game'

var state = null
var number_of_active_players = 0


func pre_game():
    $HUD.pre_game(number_of_active_players, MAX_TIME_PRE_GAME)
    update_state(PRE_GAME)


func start_game():
    $HUD.start_game( MAX_TIME_GAME)
    update_state(GAME)


func end_game():
    $HUD.end_game()
    update_state(IDLE)


func update_hud():
    if state == PRE_GAME:
        $HUD.update_time_pre_game(time_remaining)
    elif state == GAME:
        $HUD.update_time_game(time_remaining)


func update_state(_state):
    if _state == IDLE:
        pass
    elif _state == PRE_GAME:
        time_remaining = MAX_TIME_PRE_GAME
    elif _state == GAME:
        time_remaining = MAX_TIME_GAME
        
    state = _state


func update_time(delta):
    if time_remaining > 0.0:
        time_remaining = max(0.0, time_remaining - delta)
        
        if time_remaining == 0.0:
            if state == PRE_GAME:
                start_game()
            elif state == GAME:
                end_game()
    

func _ready():
    update_state(IDLE)


func _process(delta):
    update_time(delta)
    update_hud()
    
    # TODO: REMOVE THIS AT SOME POINT, OR DON'T I'M NOT THE BOSS OF YOU.
    if state == IDLE && Input.is_action_pressed('ui_up'):
        pre_game()