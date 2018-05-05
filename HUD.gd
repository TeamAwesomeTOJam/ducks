extends CanvasLayer

var MAX_PLAYERS = 4
var player_labels = {}


func update_player_score(player, score):
    player_labels[player].text = str(score)


func update_time_remaining(time_remaining):
    $LabelTimeRemaining.text = str(time_remaining)


func update_time_start(time_start):
    $LabelTimeStart.text = str(time_start)


func start_game(number_of_players, time_remaining):
    for player in range(MAX_PLAYERS):
        update_player_score(player, 0)
        if i < number_of_players:
            player_labels[player].show()
        else: 
            player_labels[player].hide()
    
    update_time_remaining(time_remaining)


func end_game():
    $LabelTimeRemaining.hide()


func _ready():
    player_labels = {
        1: $LabelPlayer1,
        2: $LabelPlayer2,
        3: $LabelPlayer3,
        4: $LabelPlayer4,
    }
    
    
    for label in player_labels.values():
        label.text = "0"
        label.hide()