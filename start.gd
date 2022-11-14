extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start_game()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$Intro.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_pressed():
	var tween = get_node("Tween")
	$Intro.stop()
	$Mecatranslation.play()
	tween.interpolate_property(self, "position",
			Vector2(0, 0), Vector2(0, -550), 0.6,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	emit_signal("start_game")
	$BO.playBO()
