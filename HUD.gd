extends CanvasLayer

var MAX_PLAYERS = 4
var player_labels = {}


func update_player_score(player, score):
    player_labels[player].text = str(score)


func update_time_game(time_remaining):
    if floor(time_remaining) <= 5:
        $LabelTimeGame.hide()
        $LabelTimePreGame.show()
        $LabelTimePreGame.text = str(floor(time_remaining))
    else:
        $LabelTimeGame.text = str(floor(time_remaining))
        
    if time_remaining <= 0.1:
        $LabelTimePreGame.hide()


func update_time_pre_game(time_remaining):
    $LabelTimePreGame.text = str(ceil(time_remaining))
   
var is_winner = false 
func winner():
    $LabelTimePreGame.text = "Winner!"
    $LabelTimePreGame.show()
    is_winner = true
    

func pre_game(number_of_players, time_remaining):
    for player in range(0, MAX_PLAYERS):
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
    
var time = 0.0
func _process(delta):
    if is_winner:
        time += delta
#        $LabelTimePreGame.add_color_override(
#            "font_color",
#            Color(
#                abs(sin(time + 0.25)),
#                1.0 - abs(sin(time + 0.5)), 
#                abs(sin(time - 0.25))
#            )
#        )
        $LabelTimePreGame.set_rotation(sin(time) * 0.05)

func _ready():
    player_labels = {
        0: $LabelPlayer1,
        1: $LabelPlayer2,
        2: $LabelPlayer3,
        3: $LabelPlayer4,
    }
    
    for label in player_labels.values():
        label.text = "0"
        label.hide()
        
        $LabelTimeGame.hide()
        $LabelTimePreGame.show()
        $LabelTimePreGame.text = "Press Start!"