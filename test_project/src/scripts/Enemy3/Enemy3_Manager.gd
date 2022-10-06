extends Node2D

export (int) var rot_speed = 2
var _offset = 0

func shoot():
	$BulletSpawner.shoot_flower()

func _on_Timer_timeout():
	if get_parent().can_shoot and not get_parent().is_dead:
		$BulletSpawner.shoot_lines(_offset)
		_offset += rot_speed % 360
