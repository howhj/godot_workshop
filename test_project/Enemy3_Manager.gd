extends Node2D

export (int) var rot_speed = 2
var _offset = 0

func shoot():
	$BulletSpawner.shoot_flower()

func _on_Timer_timeout():
	$BulletSpawner.shoot_lines(_offset)
	_offset += rot_speed
