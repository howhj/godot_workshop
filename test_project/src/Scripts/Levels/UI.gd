extends Node2D

var _player

onready var _score = $Score
onready var _lives = $Lives

const Stock = preload("res://src/Levels/Stock.tscn")

func _ready():
	_player = get_node("../Low_priority/Player")
	_life_display(Globals.lives)
	
func _physics_process(delta):
	_score.text = str(Globals.score)
	
func _life_display(lives):
	for node in _lives.get_children():
		node.queue_free()
	for i in lives - 1:
		var instance = Stock.instance()
		_lives.add_child(instance)
		instance.set_global_position(Vector2(18 + 26 * i, 50))

func _on_Player_lives_changed():
	_life_display(Globals.lives)
