extends Node2D

var _choice = 0
var _shots = 0

func shoot():
	if _choice == 0:
		$Timer.start()
		_choice = 1
		
	else:
		$BulletSpawnerM.shoot()
		_choice = 0

func _on_Timer_timeout():
	$BulletSpawnerL.shoot()
	$BulletSpawnerR.shoot()
	_shots += 1
	
	if _shots < 3:
		$Timer.start()
	else:
		_shots = 0
