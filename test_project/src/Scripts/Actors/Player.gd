extends KinematicBody2D

export (int) var speed = 400
export (int) var fire_rate = 30
export (float) var bullet_length = 3
export var respawn_pos = Vector2(384, 950)

var _cam_scale

var _frames_per_shot
var _frame_count = 0

var focus = false
var _viewport

var _power_ctr = 0
var _is_invul = true
signal lives_changed

var _anim_state = 0

onready var _bullet_spawner = $BulletSpawner
onready var _respawn_timer = $RespawnTimer
onready var _invul_timer = $InvulTimer
onready var _sprite = $AnimatedSprite

const Bullet = preload("res://src/Actors/PlayerBullet.tscn")
const Explosion = preload("res://src/Effects/Explosion.tscn")
const PowerUp = preload("res://src/Actors/PowerUp.tscn")

func _ready():
	_frames_per_shot = 60 / fire_rate
	
	_cam_scale = Globals.cam_scale
	scale = _cam_scale
	bullet_length *= _cam_scale.y
	
	_invul_timer.start()
	
	set_global_position(respawn_pos)
	_viewport = get_viewport_rect().size

func _get_input():
	var horizontal = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vertical = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if Input.get_action_strength("focus") > 0:
		focus = true
	else:
		focus = false
	_move(horizontal, vertical)
	_animate(horizontal)
	
	if Input.get_action_strength("shoot") > 0:
		if _frame_count == 0:
			_shoot()
		_frame_count = (_frame_count + 1) % _frames_per_shot

func _move(horizontal, vertical):
	var speed_mul = 1
	if focus:
		speed_mul = 0.66
	var velocity = Vector2(horizontal, vertical).normalized() * speed * speed_mul
	move_and_slide(velocity)
	
	var pos = get_global_position()
	var x_offset = 8 * _cam_scale.x
	var y_offset = 12 * _cam_scale.y
	pos.x = clamp(pos.x, x_offset, _viewport.x - x_offset)
	pos.y = clamp(pos.y, y_offset, _viewport.y - y_offset)
	set_global_position(pos)
	
func _animate(horizontal):
	if horizontal < 0:
		match _anim_state:
			-1:
				_sprite.play("left_hold")
			0:
				_sprite.play("left_bank")
				_anim_state = -2
			1:
				_sprite.play("right_return")
				_anim_state = 3
	elif horizontal == 0:
		match _anim_state:
			-1:
				_sprite.play("left_return")
				_anim_state = -3
			0:
				_sprite.play("default")
			1:
				_sprite.play("right_return")
				_anim_state = 3
	else:
		match _anim_state:
			-1:
				_sprite.play("left_return")
				_anim_state = -3
			0:
				_sprite.play("right_bank")
				_anim_state = 2
			1:
				_sprite.play("right_hold")

func _shoot():
	var power = Globals.power
	var shots = power * 2 + 1
	for i in shots:
		var offset = Vector2((i - power) * 15, bullet_length * -5)
		var pos = _bullet_spawner.get_global_position() + offset
		var instance = Globals.instantiate(Bullet, 0, pos)
		instance.scale.y = bullet_length
		
		if focus:
			instance.direction = Vector2(0, -1)
		else:
			var angle = deg2rad(270 + (i - power) * 20)
			instance.direction = Vector2(cos(angle), sin(angle))
			instance.rotation = angle + PI / 2
	
func _die():
	Globals.lives -= 1
	emit_signal("lives_changed")
	
	Globals.power = 0
	Globals.rank -= 20
	
	Globals.is_dead = true
	_is_invul = true
	hide()
	Globals.instantiate(Explosion, 0, get_global_position(), 2)
	
	if _power_ctr < 5:
		_power_ctr += 1
	for i in _power_ctr:
		var instance = Globals.instantiate(PowerUp, 0, get_global_position())
		var angle = Globals.rng.randf_range(0, 2 * PI)
		var direction = Vector2(cos(angle), sin(angle))
		instance.direction = direction
	
	if Globals.lives > 0:
		$RespawnTimer.start()

func _physics_process(delta):
	if is_visible():
		_get_input()

func _on_Hitbox_body_entered(body):
	if not _is_invul:
		_die()

func _on_ItemHitbox_body_entered(body):
	if is_visible():
		body.queue_free()
		if Globals.power < 2:
			Globals.power += 1
			Globals.score += 1000
		else:
			Globals.score += 10000

func _on_RespawnTimer_timeout():
	if not is_visible():
		set_global_position(respawn_pos)
		_respawn_timer.start()
		show()
	else:
		_invul_timer.start()
		Globals.is_dead = false

func _on_InvulTimer_timeout():
	_is_invul = false

func _on_AnimatedSprite_animation_finished():
	if _anim_state == 2:
		_anim_state = 1
	elif _anim_state == -2:
		_anim_state = -1
	elif _anim_state == 3 or _anim_state == -3:
		_anim_state = 0
