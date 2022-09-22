extends Node2D

var _choice = 0
var _shots = 0

func shoot():
	if _choice == 0:
		$Timer.start()
		_shots += 1
		_choice = 1
	else:
		$BulletSpawnerM.shoot()
		_choice = 0

func _on_Timer_timeout():
	$BulletSpawnerL.shoot()
	$BulletSpawnerR.shoot()
	if _shots < 3:
		$Timer.start()
		_shots += 1
	else:
		_shots = 0
