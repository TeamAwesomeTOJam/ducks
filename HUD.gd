extends CanvasLayer

var MAX_PLAYERS = 4
var player_labels = {}


func update_player_score(player, score):
    player_labels[player].text = str(score)


func update_time_game(time_remaining):
    $LabelTimeGame.text = str(floor(time_remaining))


func update_time_pre_game(time_remaining):
    $LabelTimePreGame.text = str(ceil(time_remaining))
    

func pre_game(number_of_players, time_remaining):
    for player in range(1, MAX_PLAYERS + 1):
        update_player_score(player, 0)
        if player <= number_of_players:
            player_labels[player].show()
        else: 
            player_labels[player].hide()
    
    $LabelTimePreGame.show()
    update_time_pre_game(time_remaining)


func start_game(time_remaining):
    $LabelTimePreGame.hide()
    $LabelTimeGame.show()
    update_time_game(time_remaining)


func end_game():
    $LabelTimeGame.hide()


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
        
        $LabelTimeGame.hide()
        $LabelTimePreGame.hide()