extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$round_1.visible=false
	$round_2.visible=false
	$round_3.visible=false
	pass # Replace with function body.
	#showround(0)

func showround(n):
	if n == 1:
		$round_1.visible=true
		$round_2.visible=false
		$round_3.visible=false
	elif n == 2:
		$round_1.visible=false
		$round_2.visible=true
		$round_3.visible=false
	elif n == 3:
		$round_1.visible=false
		$round_2.visible=false
		$round_3.visible=true
	
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
			Vector2(0, -70), Vector2(0, +100), 0.6,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	var timer = get_tree().create_timer(2) 
	yield(timer,"timeout")
	
	tween.interpolate_property(self, "position",
			Vector2(0, 70), Vector2(0, -140), 0.6,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
