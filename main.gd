extends Node2D


# Blob
var BlobBody = preload("res://parts/blob/BlobBody.tscn")

# Iguane
var IgBody = preload("res://parts/ig/IgBody.tscn")
var IgTail = preload("res://parts/ig/IgTail.tscn")
var IgHead = preload("res://parts/ig/IgHead.tscn")
var IgHind = preload("res://parts/ig/IgHind.tscn")
var IgFront = preload("res://parts/ig/IgFront.tscn")

# Lion
var LionBody = preload("res://parts/lion/LionBody.tscn")
var LionTail = preload("res://parts/lion/LionTail.tscn")
var LionHead = preload("res://parts/lion/LionHead.tscn")
var LionFront = preload("res://parts/lion/LionFront.tscn")
var LionHind = preload("res://parts/lion/LionHind.tscn")

# Paon
var PaonBody = preload("res://parts/paon/PaonBody.tscn")
var PaonTail = preload("res://parts/paon/PaonTail.tscn")
var PaonHead = preload("res://parts/paon/PaonHead.tscn")
var PaonFront = preload("res://parts/paon/PaonFront.tscn")
var PaonHind = preload("res://parts/paon/PaonHind.tscn")

# Poisson
var PoissonBody = preload("res://parts/poisson/PoissonBody.tscn")
var PoissonTail = preload("res://parts/poisson/PoissonTail.tscn")
var PoissonHead = preload("res://parts/poisson/PoissonHead.tscn")
var PoissonFront = preload("res://parts/poisson/PoissonFront.tscn")
var PoissonHind = preload("res://parts/poisson/PoissonHind.tscn")

var bodies = [IgBody, LionBody, PaonBody, PoissonBody]
var heads = [IgHead, LionHead, PaonHead, PoissonHead]
var tails = [IgTail, LionTail, PaonTail, PoissonTail]
var fronts = [IgFront, LionFront, PaonFront, PoissonFront]
var hinds = [IgHind, LionHind, PaonHind, PoissonHind]

var parts = bodies + heads + tails + fronts + hinds

onready var fiole1 = $Fiole1
onready var fiole2 = $Fiole2
onready var fiole3 = $Fiole3

onready var model : Creature = $Model
onready var creature1 = $Creature1
onready var creature2 = $Creature2
onready var creature3 = $Creature3
onready var creature4 = $Creature4

onready var players = [creature1, creature2, creature3, creature4]
var players_score = [0, 0, 0, 0]
var player_idx := 0
var turn := 0
var match_round := 1

var carried : Fiole = null
var release_switch = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	$UILayer/start.connect("start_game", self, "_on_start_game")
	
	fiole1.connect("fiole_picked", self, "_on_fiole_picked")
	fiole2.connect("fiole_picked", self, "_on_fiole_picked")
	fiole3.connect("fiole_picked", self, "_on_fiole_picked")
	fiole1.connect("fiole_released", self, "_on_fiole_released")
	fiole2.connect("fiole_released", self, "_on_fiole_released")
	fiole3.connect("fiole_released", self, "_on_fiole_released")
	fiole1.connect("fiole_mouse_entered", self, "_on_fiole_mouse_entered")
	fiole2.connect("fiole_mouse_entered", self, "_on_fiole_mouse_entered")
	fiole3.connect("fiole_mouse_entered", self, "_on_fiole_mouse_entered")
	fiole1.pos_init = fiole1.position
	fiole2.pos_init = fiole2.position
	fiole3.pos_init = fiole3.position
	
	creature1.connect("fiole_dropped", self, "_on_creature_mouse_released")
	creature2.connect("fiole_dropped", self, "_on_creature_mouse_released")
	creature3.connect("fiole_dropped", self, "_on_creature_mouse_released")
	creature4.connect("fiole_dropped", self, "_on_creature_mouse_released")
	creature1.connect("mouse_entered", self, "_on_creature_mouse_entered")
	creature2.connect("mouse_entered", self, "_on_creature_mouse_entered")
	creature3.connect("mouse_entered", self, "_on_creature_mouse_entered")
	creature4.connect("mouse_entered", self, "_on_creature_mouse_entered")
	
	fiole1.visible = false
	fiole2.visible = false
	fiole3.visible = false

	creature1.visible = false
	creature2.visible = false
	creature3.visible = false
	creature4.visible = false
	
	resetGame()
	
	players[player_idx].highlight(true)



func _process(delta):
	if release_switch:
		# Executed after recieving signals from fiole and creature
		release_switch = false
		carried = null


func rematch():
	remodel()
	for c in players:
		c.reset()
		c.visible = true
	fiole1.visible = true
	fiole2.visible = true
	fiole3.visible = true
	$Round.showround(match_round)


func resetGame():
#	fiole1.visible = false
#	fiole2.visible = false
#	fiole3.visible = false
#	creature1.visible = false
#	creature2.visible = false
#	creature3.visible = false
#	creature4.visible = false

	for c in players:
		c.reset()
	
	player_idx = 0
	players_score = [0, 0, 0, 0]
	turn = 0
	match_round = 1
	
	remodel()
	reroll()


func remodel():
	model.modulate = Color(0, 0, 0, 1)
	model.reset()
	var randomBody = bodies[randi() % len(bodies)]
	model.addPart(randomBody.instance(), "body")
	var randomHead = heads[randi() % len(heads)]
	model.addPart(randomHead.instance(), "head")
	var randomTail = tails[randi() % len(tails)]
	model.addPart(randomTail.instance(), "tail")
	var randomFront = fronts[randi() % len(fronts)]
	model.addPart(randomFront.instance(), "front")
	var randomHind = hinds[randi() % len(hinds)]
	model.addPart(randomHind.instance(), "hind")


func reroll():
	var part_idx = randi() % len(parts)
	var randomPart = parts[part_idx]
	fiole1.setPart(randomPart.instance(), part_idx)
	part_idx = randi() % len(parts)
	randomPart = parts[part_idx]
	fiole2.setPart(randomPart.instance(), part_idx)
	part_idx = randi() % len(parts)
	randomPart = parts[part_idx]
	fiole3.setPart(randomPart.instance(), part_idx)


func score(creature : Creature):
	var score = 0
	if creature.body.name == model.body.name:
		score += 1
	
	for h in creature.heads:
		if h.name == model.heads[0].name:
			score += 1
		else:
			score -= 1
	for t in creature.tails:
		if t.name == model.tails[0].name:
			score += 1
		else:
			score -= 1
	for f in creature.fronts:
		if f.name == model.fronts[0].name:
			score += 1
		else:
			score -= 1
	for h in creature.hinds:
		if h.name == model.hinds[0].name:
			score += 1
		else:
			score -= 1
	
	return score


func _on_start_game():
	creature1.visible = true
	creature2.visible = true
	creature3.visible = true
	creature4.visible = true
	fiole1.visible = true
	fiole2.visible = true
	fiole3.visible = true
	$Round.showround(1)


func _on_creature_mouse_entered(creature : Creature):
	if carried:
		creature.shake()


func _on_fiole_picked(fiole : Fiole):
	carried = fiole


func _on_fiole_released(fiole : Fiole):
	release_switch = true


func _on_fiole_mouse_entered(fiole : Fiole):
	if not carried:
		fiole.shake()


func _on_creature_mouse_released(creature : Creature):
	if carried != null:
		# Fiole dropped on creature
		if randf() < carried.mutate_prob:
			# Success
			var part_name = carried.part.name
			if part_name.begins_with("Lion"):
				$crianim.play()
			elif part_name.begins_with("Paon"):
				$crianimpaon.play()
			elif part_name.begins_with("Ig"):
				$crianimlezard.play()
			elif part_name.begins_with("Poisson"):
				$crianimpoisson.play()
			
			if part_name.ends_with("Body"):
				part_name = "body"
			elif part_name.ends_with("Head"):
				part_name = "head"
			elif part_name.ends_with("Tail"):
				part_name = "tail"
			elif part_name.ends_with("Front"):
				part_name = "front"
			elif part_name.ends_with("Hind"):
				part_name = "hind"
			var new_part = parts[carried.part_type]
			creature.addPart(new_part.instance(), part_name)
		else:
			# Failure !
			$CHOKEE.play()
			var part_name = ["head", "tail", "front", "hind"][randi() % 4]
			var new_part = parts[randi() % len(parts)]
			if new_part in bodies:
				part_name = "body"
			var partinsance = new_part.instance()
			creature.addPart(partinsance, part_name)
			
			if partinsance.name.begins_with("Lion"):
				$crianim.play()
			if partinsance.name.begins_with("Paon"):
				$crianimpaon.play()
			if partinsance.name.begins_with("Ig"):
				$crianimlezard.play()
			if partinsance.name.begins_with("Poisson"):
				$crianimpoisson.play()
		carried = null
		
		# Next player
		players[player_idx].highlight(false)
		player_idx += 1
		if player_idx == 4:
			# end of turn
			player_idx = 0
			turn += 1
			if turn == 6:
				turn = 0
				print("fin de manche")
				var max_score = -999
				var winner = null
				for c in range(4):
					var s = score(players[c])
					print(players[c], s)
					if s > max_score:
						max_score = s
						winner = c
				print(winner, " ", max_score)
				for i in range(4):
						if i != winner:
							players[i].visible = false
				fiole1.visible = false
				fiole2.visible = false
				fiole3.visible = false
				var tween = get_node("Tween")
				tween.interpolate_property(model, "modulate",
					Color(0, 0, 0, 1), Color(1, 1, 1, 1), 1.5,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
				$reveal.play()
				var timer = get_tree().create_timer(4)
				yield(timer, "timeout")
				
				players_score[winner] += 1
				
				match_round += 1
				if match_round <= 3:
					rematch()
					
				else:
					# end of game
					var n = 0
					var max_win = 0
					for i in range(4):
						if players_score[i] > max_win:
							n = i
							max_win = players_score[i]
					print("winner ", players[n])
					
					var winScreen = preload("res://WinScreen.tscn").instance()
					add_child(winScreen)
					
					timer = get_tree().create_timer(4)
					yield(timer, "timeout")
					winScreen.queue_free()
					resetGame()
					_on_start_game()
		
		reroll()
		players[player_idx].highlight(true)
