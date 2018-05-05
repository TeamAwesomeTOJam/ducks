extends Node


var game_handle_time = null
var time_remaining = 0.0

var MAX_TIME_PRE_GAME = 5.0
var MAX_TIME_GAME = 100.0


var IDLE = 'idle'
var PRE_GAME = 'pre_game'
var GAME = 'game'

var state = null
var number_of_players = 0

func update_state(_state):
    if _state == IDLE:
        pass
    elif _state == PRE_GAME:
        time_remaining = MAX_TIME_PRE_GAME
    elif _state == GAME:
        time_remaining = MAX_GAME
        
    state = _state

func handle_transition():
    if state == PRE_GAME:
        start_game()
    elif state == GAME:
        end_game()


func start_game():
    $HUD.start_game(number_of_players, MAX_TIME_GAME)
    state = GAME


func end_game():
    $HUD.end
    state = IDLE


func _ready():
    state = IDLE


func _process(delta):
    if time_remaining > 0.0:
        time_remaining = max(0.0, time_remaining - delta)
        
        if time_temaining == 0.0:
            handle_transition()