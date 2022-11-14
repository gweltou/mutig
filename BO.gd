extends AudioStreamPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var playlist = ["gibcake beat","flamand rose","cheap lean",
	"do you","Mandies master1","Miles","mission","sell2tr3","welles mix 1"
	
]
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func playBO()-> void:
	index = randi() % len(playlist)
	stream = load("res://audio/BO/"+ playlist[index] + ".ogg")
	play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BO_finished():
	index = index+1
	if index == len(playlist):
		index = 0
	stream = load("res://audio/BO/"+ playlist[index] + ".wav")
#	stream = load("res://audio/BO/"+ track + ".wav")
	play()
	
	pass # Replace with function body.
