extends Node2D

var _choice = 0
var _count = 0

func shoot():
	if _choice == 0:
		$Bullet_spawner_M.shoot()
		_choice = 1
	else:
		$Timer.start()
		_count += 1
		_choice = 0

func _on_Timer_timeout():
	if _count < 3:
		$Timer.start()
		_count += 1
	else:
		_count = 0
