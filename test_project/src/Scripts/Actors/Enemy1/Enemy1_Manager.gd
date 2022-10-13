extends Node2D

var _max_shots = 1
var _shot_ctr = 0
var _wait_time = 0.5
var is_shooting = false
var shot_speed = 0
var _player_pos

var _main
var _player

onready var _timer = $ShootTimer
onready var _bullet_spawner = $BulletSpawner

func _ready():
	if Globals.difficulty == 1:
		_max_shots = 10
		_wait_time = 0.1
		shot_speed = 300
	_main = get_node("../..")
	_player = _main.get_node("../Player/Hitbox")

func _on_ShootTimer_timeout():
	if _main.can_shoot and not is_shooting:
		is_shooting = true
		if not Globals.is_dead:
			_player_pos = _player.get_global_position()
		else:
			_player_pos = null
			
	if is_shooting:
		if _player_pos != null:
			_bullet_spawner.shoot(_player_pos)
			
		_shot_ctr += 1
		if _shot_ctr < _max_shots:
			_timer.start(0.05)
		else:
			_timer.start(_wait_time)
			_shot_ctr = 0
			is_shooting = false
