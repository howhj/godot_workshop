extends KinematicBody2D

export (int) var speed = 300

export (int) var lives = 10
var is_dead = false
var _is_invul = false
export var spawn_location = Vector2(359, 950)

const Bullet = preload("res://src/actors/Player_bullet.tscn")
const Explosion = preload("res://src/Explosion.tscn")
const PowerUp = preload("res://src/actors/PowerUp.tscn")

var _scale_mul = Vector2()
export (int) var fire_rate = 15
var _current_frame = 0
var _max_frames

var _anim_state = 0 # -3 (left) to 3 (right)
onready var _sprite = $AnimatedSprite

var _power = 0
var _power_ctr = 0
var _rng
var _focus = false

func _ready():
	_max_frames = 60 / fire_rate
	var scale_value = get_parent().scale_value
	_scale_mul = Vector2(scale_value, scale_value)
	set_scale(_scale_mul)
	set_global_position(spawn_location)
	_rng = RandomNumberGenerator.new()
	_rng.randomize()

func _physics_process(delta):
	if is_visible():
		_move()
		
		if Input.get_action_strength("focus") > 0:
			_focus = true
		else:
			_focus = false
		
		if Input.get_action_strength("shoot") > 0:
			_shoot()
			
func _move():
		var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		var direction = Vector2(horizontal, vertical).normalized()
		var speed_mul = 1
		if _focus:
			speed_mul = 0.66
		move_and_slide(direction * speed * speed_mul)
		
		var x_offset = 8 * scale.x
		var y_offset = 12 * scale.y
		var viewport = get_viewport_rect().size
		var pos = get_global_position()
		pos.x = clamp(pos.x, x_offset, viewport.x - x_offset)
		pos.y = clamp(pos.y, y_offset, viewport.y - y_offset)
		set_global_position(pos)
		
		_animate(horizontal)
			
			
func _shoot():
	if _current_frame == 0:
		var parent = get_node("/root/Node2D")
		var pos = $Bullet_spawner.get_global_position()
		for i in _power * 2 + 1:
			var bullet_pos = pos
			bullet_pos.x += (i - _power) * 15
			var instance = _instantiate(Bullet, parent, bullet_pos, _scale_mul)
			if not _focus:
				var angle = deg2rad(270 + (i - _power) * 20)
				var direction = Vector2(cos(angle), sin(angle))
				instance.direction = direction
				instance.rotation = angle + PI / 2
	_current_frame = (_current_frame + 1) % _max_frames
	
func _animate(horizontal):
	if horizontal > 0:
		match _anim_state:
			-1:
				_sprite.play("from_left")
				_anim_state = -3
			0:
				_sprite.play("to_right")
				_anim_state = 2
			1:
				_sprite.play("hold_right")
	elif horizontal < 0:
		match _anim_state:
			-1:
				_sprite.play("hold_left")
			0:
				_sprite.play("to_left")
				_anim_state = -2
			1:
				_sprite.play("from_right")
				_anim_state = 3
	else:
		match _anim_state:
			-1:
				_sprite.play("from_left")
				_anim_state = -3
			0:
				_sprite.play("default")
			1:
				_sprite.play("from_right")
				_anim_state = 3
	
func _instantiate(prefab, parent, pos, scale_mul):
	var instance = prefab.instance()
	instance.global_position = pos
	instance.set_scale(scale_mul)
	parent.add_child(instance)
	return instance

func _on_Hitbox_body_entered(body):
	if not _is_invul:
		lives -= 1
		_power = 0
		if _power_ctr < 5:
			_power_ctr += 1
		is_dead = true
		_is_invul = true
		hide()
		
		var parent = get_node("/root/Node2D")
		var pos = get_global_position()
		_instantiate(Explosion, parent, pos, _scale_mul * 2)
		
		for i in _power_ctr:
			var angle = _rng.randf_range(0, 2 * PI)
			var direction = Vector2(cos(angle), sin(angle))
			var instance = _instantiate(PowerUp, parent, pos, _scale_mul)
			instance.direction = direction
		
		if lives > 0:
			$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	if not is_visible():
		$RespawnTimer.start()
		show()
		set_global_position(spawn_location)
	else:
		is_dead = false
		$InvulTimer.start()

func _on_InvulTimer_timeout():
	_is_invul = false

func _on_AnimatedSprite_animation_finished():
	if _anim_state == 3 or _anim_state == -3:
		_anim_state = 0
	elif _anim_state == 2:
		_anim_state = 1
	elif _anim_state == -2:
		_anim_state = -1

func _on_ItemHitbox_body_entered(body):
	if not is_dead:
		body.queue_free()
		if _power < 2:
			_power += 1
