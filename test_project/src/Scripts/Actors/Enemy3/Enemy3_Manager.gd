extends Node2D

export (int) var spin_speed = 2

var _offset = 0
var _wait_time = 1
var shot_speed = 0

var _main

onready var _bullet_spawner = $BulletSpawner
onready var _flower_timer = $FlowerTimer

func _ready():
	if Globals.difficulty == 1:
		_wait_time = 0.5
		_flower_timer.start(_wait_time)
		shot_speed = 50
	_main = get_node("../..")
	
func _on_FlowerTimer_timeout():
	if _main.can_shoot and not Globals.is_dead:
		_bullet_spawner.shoot_flower()

func _on_LineTimer_timeout():
	if _main.can_shoot and not Globals.is_dead:
		_bullet_spawner.shoot_lines(_offset)
	_offset += spin_speed
