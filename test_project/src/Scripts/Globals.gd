extends Node

var difficulty = 0
var rank = 0
var score = 0
var rng

var power = 0
var lives = 3
var is_dead = false

var cam_scale = Vector2(3, 3)
var cam_velocity = Vector2(0, 50)

var _score_extends = [20000, 100000]
var _extend_ptr = 0
var _player

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
func _physics_process(delta):
	if _extend_ptr < _score_extends.size() and score > _score_extends[_extend_ptr]:
		lives += 1
		_extend_ptr += 1
		if _player == null:
			_player = get_node("/root/Level/Low_priority/Player")
		_player.emit_signal("lives_changed")

func instantiate(prefab, parent, pos, scale_mul=1):
	var instance = prefab.instance()
	var parent_node
	if parent == 0:
		parent_node = get_node("/root/Level/Low_priority")
	else:
		parent_node = get_node("/root/Level/High_priority")
	parent_node.add_child(instance)
	instance.set_global_position(pos)
	instance.set_scale(cam_scale * scale_mul)
	return instance
