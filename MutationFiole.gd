extends Node2D
class_name Fiole


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var part = null
var part_type := 0
var rotSpeed := 1.0
var drag_enabled = false
var click_location := Vector2.ZERO
var pos_init : Vector2
var mutate_prob = 1.0

var scl = 0.22
var scale_orig
var tweening = false

signal fiole_picked(fiole)
signal fiole_released(fiole)
signal fiole_mouse_entered(fiole)


# Called when the node enters the scene tree for the first time.
func _ready():
	scale_orig = self.scale
	pass # Replace with function body.



func _process(delta):
	if part != null:
		part.rotate(delta * rotSpeed)


func setPart(new_part, type : int):
	rotSpeed = (randf() + 1) * 0.2
	mutate_prob = min(1, randf() * 2)
	$Label.text = "%d %%" % (mutate_prob * 100)
	if mutate_prob > 0.75:
		$Label.set("custom_colors/font_color",Color(0,1,0))
	elif mutate_prob > 0.5:
		$Label.set("custom_colors/font_color",Color(1,1,0))
	elif mutate_prob > 0.25:
		$Label.set("custom_colors/font_color",Color(1,0.5,0))
	else:
		$Label.set("custom_colors/font_color",Color(1,0,0))
		
	part_type = type
	var texSize = new_part.texture.get_size()
	new_part.offset = Vector2.ZERO
	new_part.scale *= scl
	new_part.translate(-new_part.offset * scl)
	new_part.position.y = -90
	if part != null:
		part.queue_free()
	part = new_part
	part.z_index -= 1
	add_child(part)

func _input(event):
#	if event is InputEventMouseButton and not event.pressed:
#		emit_signal("fiole_released", self)
#		self.position = pos_init
#		drag_enabled = false
		
	if drag_enabled:
		if event is InputEventMouseMotion:
			position = get_global_mouse_position() - click_location
		elif event is InputEventMouseButton and not event.pressed:
			emit_signal("fiole_released", self)
			self.position = pos_init
			drag_enabled = false


func shake():
	if not tweening:
		tweening = true
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "scale", scale_orig * 1.1, 0.12)
		tween.tween_property(self, "scale", scale_orig , 0.12)
		tween.tween_callback(self, "_tween_end")

func _tween_end():
	tweening = false


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed and not drag_enabled:
				drag_enabled = true
				click_location = to_local(event.position) * scl
				emit_signal("fiole_picked", self)
				$AudioStreamPlayer.play()
			else:
				drag_enabled = false


func _on_Area2D_mouse_entered():
	emit_signal("fiole_mouse_entered", self)

