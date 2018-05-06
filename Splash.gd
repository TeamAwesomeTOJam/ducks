extends AnimatedSprite


func _ready():
    self.frame = 0

func _on_Splash_animation_finished():
    self.queue_free()
