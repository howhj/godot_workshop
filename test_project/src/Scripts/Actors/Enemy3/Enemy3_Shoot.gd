extends Position2D

var _scale_mul

var petals = 5
var density = 2
var _interval
var _sub_interval

const Bullet = preload("res://src/Actors/EnemyBullet.tscn")

func _ready():
	_scale_mul = get_node("../../..").custom_scale
	_interval = 360 / petals
	_sub_interval = _interval / density / 2
	
func _create_bullet(pos, angle, speed=200, scale_mul=1):
	var bullet_instance = Globals.instantiate(Bullet, 1, pos, scale_mul)
	bullet_instance.direction = Vector2(cos(angle), sin(angle))
	bullet_instance.speed = speed + Globals.rank + get_parent().shot_speed

func shoot_flower():
	var pos = get_global_position()
	for i in petals:
		var player_pos = get_node("../../../../Player/Hitbox").get_global_position()
		var direction = player_pos - pos
		var base_angle = rad2deg(direction.angle()) + _interval * (i + 0.5)
		
		for j in density * 2:
			base_angle += _sub_interval
			var speed = 200
			if j < density:
				speed += 100 / density * (density - j)
			else:
				speed += 100 / density * (j - density)
			_create_bullet(pos, deg2rad(base_angle), speed, _scale_mul)

func shoot_lines(offset):
	var pos = get_global_position()
	for i in 5:
		var angle = deg2rad(270 + 72 * i + offset)
		_create_bullet(pos, angle)

