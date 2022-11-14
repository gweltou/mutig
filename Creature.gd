extends Node2D
class_name Creature




onready var body = $BlobBody
onready var scl = scale.x

var heads := []
var tails := []
var fronts := []
var hinds := []

var tweening = false

signal fiole_dropped(creature)
signal mouse_entered(creature)


func _ready():
	body.get_node("vecHead").visible = false
	body.get_node("vecTail").visible = false
	body.get_node("vecFront").visible = false
	body.get_node("vecHind").visible = false


func _process(delta):
	pass
	

func highlight(val : bool):
	var tween = $Tween
	if val == true:
		z_index += 1
		tween.interpolate_property(self, "scale", Vector2(scl, scl), Vector2(scl*1.5, scl*1.5), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		tween.interpolate_property(self, "modulate", Color(1,1,1,0.5), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		z_index -= 1
		tween.interpolate_property(self, "scale", Vector2(scl*1.5, scl*1.5), Vector2(scl, scl), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0.5), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func reset():
	for h in heads:
		h.queue_free()
	heads.clear()
	for t in tails:
		t.queue_free()
	tails.clear()
	for f in fronts:
		f.queue_free()
	fronts.clear()
	for h in hinds:
		h.queue_free()
	hinds.clear()
	
	if body != $BlobBody:
		body.queue_free()
		body = $BlobBody
		$BlobBody.visible = true


func addPart(part : Sprite, location : String):
#	part.use_parent_material = true
	
	if location == "body":
		$BlobBody.visible = false
		if body != $BlobBody:
			body.queue_free()
		body = part
		add_child(part)
		part.get_node("vecHead").visible = false
		part.get_node("vecTail").visible = false
		part.get_node("vecFront").visible = false
		part.get_node("vecHind").visible = false
		
	elif location == "tail":
#		part.scale.y = -1
		var partVec = part.get_node("vec")
		var partAnchor = partVec.points[0] # + partVec.position
		var partRot = (partVec.points[1] - partAnchor).angle()
		
		var bodyVec = body.get_node("vecTail")
		var bodyAnchor = bodyVec.points[0] + bodyVec.position
		var bodyAnchorRot = (bodyVec.points[1] + bodyVec.position - bodyAnchor).angle()

		part.translate(bodyAnchor - partAnchor)
		part.rotate(partRot + bodyAnchorRot - PI)
		
		if len(tails) > 0:
			part.rotate(2 * (randf() - 0.5))
		
		tails.append(part)
		add_child(part)
		part.get_node("vec").visible = false
		
		part.z_index = body.z_index - 1
	
	elif location == "head":
		var partVec = part.get_node("vec")
		var partAnchor = partVec.points[0] #+ part.position
		var partRot = (partVec.points[1] - partAnchor).angle()
		
		var bodyVec = body.get_node("vecHead")
		var bodyAnchor = bodyVec.points[0] + bodyVec.position #+ body.position
		var bodyAnchorRot = (bodyVec.points[1] + bodyVec.position - bodyAnchor).angle()
		
		part.translate(bodyAnchor - partAnchor)
		part.rotate(partRot - bodyAnchorRot + PI)
		if len(heads) > 0:
			part.rotate(2 * (randf() - 0.5))
		
		#part.z_index = bodyLayer - 1
		heads.append(part)
		add_child(part)
		part.get_node("vec").visible = false
	
	elif location == "hind":
		var partVec = part.get_node("vec")
		var partAnchor = partVec.points[0] #+ part.position
		var partRot = (partVec.points[1] - partAnchor).angle()
		
		var bodyVec = body.get_node("vecHind")
		var bodyAnchor = bodyVec.points[0] + bodyVec.position
		var bodyAnchorRot = (bodyVec.points[1] + bodyVec.position - bodyAnchor).angle()
		
		part.translate(bodyAnchor - partAnchor)
		part.rotate(partRot - bodyAnchorRot + PI)
		if len(hinds) > 0:
			part.rotate(2 * (randf() - 0.5))
		
#		part.z_index = bodyLayer - 1
		hinds.append(part)
		add_child(part)
		part.get_node("vec").visible = false
	
	elif location == "front":
		var partVec = part.get_node("vec")
		var partAnchor = partVec.points[0] #+ part.position
		var partRot = (partVec.points[1] - partAnchor).angle()
		
		var bodyVec = body.get_node("vecFront")
		var bodyAnchor = bodyVec.points[0] + bodyVec.position
		var bodyAnchorRot = (bodyVec.points[1] + bodyVec.position - bodyAnchor).angle()
		
		part.translate(bodyAnchor - partAnchor)
		part.rotate(partRot - bodyAnchorRot + PI)
		if len(fronts) > 0:
			part.rotate(2 * (randf() - 0.5))
		
#		part.z_index = bodyLayer - 1
		fronts.append(part)
		add_child(part)
		part.get_node("vec").visible = false


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if not event.pressed:
				emit_signal("fiole_dropped", self)


func _on_Area2D_mouse_entered():
	emit_signal("mouse_entered", self)


func shake():
	if not tweening:
		var scale_orig = self.scale
		tweening = true
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "scale", scale_orig * 1.1, 0.12)
		tween.tween_property(self, "scale", scale_orig , 0.12)
		tween.tween_callback(self, "_tween_end")

func _tween_end():
	tweening = false
