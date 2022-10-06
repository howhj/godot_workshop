extends Position2D

const Bullet = preload("res://src/actors/EnemyBullet.tscn")
var _scale_value

func _ready():
	_scale_value = get_node("../../..").scale.x
	print(_scale_value)
	
func _create_bullet(pos, scale_val, angle, speed=200):
	var bullet_instance = Bullet.instance()
	bullet_instance.global_position = pos
	bullet_instance.set_scale(Vector2(scale_val, scale_val))
	get_tree().get_root().add_child(bullet_instance)
	bullet_instance.direction = Vector2(cos(angle), sin(angle))
	bullet_instance.speed = speed

func shoot_flower():
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null and not player.get_parent().is_dead:
		for i in 5:
			var pos = get_global_position()
			var player_pos = player.get_global_position()
			var direction = player_pos - pos
			var base_angle = rad2deg(direction.angle()) + 72 * i
			
			var angle = deg2rad(base_angle)
			_create_bullet(pos, _scale_value, angle, 300)
			
			angle = deg2rad(base_angle + 18)
			_create_bullet(pos, _scale_value, angle, 250)
			
			angle = deg2rad(base_angle + 36)
			_create_bullet(pos, _scale_value, angle)
			
			angle = deg2rad(base_angle + 54)
			_create_bullet(pos, _scale_value, angle, 250)

func shoot_lines(offset):
	var player = get_node_or_null("/root/Node2D/Player/Hitbox")
	if player != null and not player.get_parent().is_dead:
		for i in 5:
			var pos = get_global_position()
			var angle = deg2rad(270 + 72 * i + offset)
			_create_bullet(pos, _scale_value/2, angle)

