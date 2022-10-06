extends Node2D

export (int) var max_hp = 3
var _current_hp

var _parent
var _scroll_velocity
export (float) var custom_scale = 1

export (int) var num_exp = 1

var can_shoot = false
var pre_spawn = true
var is_dead = false

var _rng
var _scale_mul = Vector2()
const Explosion = preload("res://src/Explosion.tscn")

export (bool) var drop_power_up = false
const PowerUp = preload("res://src/actors/PowerUp.tscn")

func _ready():
	_current_hp = max_hp
	_parent = get_parent()
	var level = _parent.get_parent()
	_scroll_velocity = level.scroll_velocity
	var scale_value = level.scale_value
	_scale_mul = Vector2(scale_value, scale_value) * custom_scale
	_parent.set_scale(_scale_mul)
	_rng = RandomNumberGenerator.new()
	_rng.randomize()

func _physics_process(delta):
	if pre_spawn:
		_parent.move_and_slide(_scroll_velocity * delta)
	if is_dead:
		var hurtbox = get_node("../CollisionShape2D")
		hurtbox.scale = Vector2.ZERO
		
func _instantiate(prefab, parent, pos, scale_mul):
	var instance = prefab.instance()
	instance.global_position = pos
	instance.set_scale(scale_mul)
	parent.add_child(instance)
	return instance

func _on_VisibilityNotifier2D_screen_exited():
	_parent.queue_free()
	
func _on_Hitbox_body_entered(body):
	body.queue_free()
	_current_hp -= 1
	if _current_hp == 0:
		if num_exp == 1:
			_parent.queue_free()
			var parent = get_node("/root/Node2D")
			var pos = get_global_position()
			_instantiate(Explosion, parent, pos, scale * 2)
			if drop_power_up:
				var angle = _rng.randf_range(0, 2 * PI)
				var direction = Vector2(cos(angle), sin(angle))
				var instance = _instantiate(PowerUp, parent, pos, _scale_mul)
				instance.direction = direction
		else:
			$ExplodeTimer.start()
			is_dead = true

func _on_ExplodeTimer_timeout():
	var pos = get_global_position()
	var parent = get_node("/root/Node2D")
	if num_exp > 1:
		var x = _rng.randf_range(-50, 50)
		var y = _rng.randf_range(-50, 50)
		pos += Vector2(x, y)
		_instantiate(Explosion, parent, pos, _scale_mul * 1.25)
		num_exp -= 1
	else:
		_parent.queue_free()
		_instantiate(Explosion, parent, pos, _scale_mul * 2)
		if drop_power_up:
			var angle = _rng.randf_range(0, 2 * PI)
			var direction = Vector2(cos(angle), sin(angle))
			var instance = _instantiate(PowerUp, parent, pos, _scale_mul)
			instance.direction = direction

func _on_ShootTimer_timeout():
	if can_shoot and not is_dead:
		$Manager.shoot()

func _on_VisibilityEnabler2D_screen_entered():
	pre_spawn = false
