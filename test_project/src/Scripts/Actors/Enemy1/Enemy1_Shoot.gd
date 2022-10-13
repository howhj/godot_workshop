extends Position2D

const Bullet = preload("res://src/Actors/EnemyBullet.tscn")

func shoot(target):
	var pos = get_global_position()
	var vector = target - pos
	if vector.length() > 200:
		var instance = Globals.instantiate(Bullet, 1, pos)
		instance.direction = vector.normalized()
		instance.speed += Globals.rank + get_parent().shot_speed
