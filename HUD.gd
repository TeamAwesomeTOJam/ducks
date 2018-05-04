extends CanvasLayer

var player_labels = {}


func update_player_score(player, score):
	player_labels[player].text = str(score)


func update_time_remaining(time_remaining):
	$LabelTimeRemaining.text = str(time_remaining)
	

func update_time_start(time_start):
	$LabelTimeStart.text = str(time_start)
	
	
func start_game(time_remaining):
	for label in player_labels.values():
		label.text = "0"
		label.show()
		
	update_time_remaining(time_remaining)


func end_game():
	$LabelTimeRemainingg.hide()


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