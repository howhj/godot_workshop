extends Node2D

export (int) var max_hp = 1
export (float) var custom_scale = 1
export (int) var explosion_count = 1
export (bool) var drop_power_up = false
export (int) var point_value = 1000

var pre_spawn = true
var is_invul = true
var can_shoot = false

var current_hp
var is_dead = false
var _explode_timer

onready var _body = $KinematicBody2D
onready var _hitbox = $KinematicBody2D/Hitbox

const Explosion = preload("res://src/Effects/Explosion.tscn")
const PowerUp = preload("res://src/Actors/PowerUp.tscn")

func _ready():
	current_hp = max_hp
	_body.scale = Globals.cam_scale * custom_scale
	
func _physics_process(delta):
	if pre_spawn:
		_body.move_and_slide(Globals.cam_velocity)
	
func _explode(scale_mul=2, offset=Vector2(0,0)):
	var pos = _body.get_global_position() + offset
	Globals.instantiate(Explosion, 0, pos, custom_scale * scale_mul)
	
func _die():
	_explode()
	queue_free()
	if drop_power_up:
		var instance = Globals.instantiate(PowerUp, 0, _body.get_global_position())
		var angle = Globals.rng.randf_range(0, 2 * PI)
		var direction = Vector2(cos(angle), sin(angle))
		instance.direction = direction

func _on_VisibilityEnabler2D_screen_entered():
	pre_spawn = false

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Hitbox_body_entered(body):
	if not is_invul and not is_dead:
		body.queue_free()
		current_hp -= 1
		Globals.score += 100
		if current_hp == 0:
			_body.get_node("CollisionShape2D").scale = Vector2.ZERO
			Globals.score += point_value
			
			if explosion_count > 1:
				can_shoot = false
				is_dead = true
				_explode_timer = $ExplodeTimer
				_explode_timer.start()
			else:
				_die()

func _on_ExplodeTimer_timeout():
	var x = Globals.rng.randf_range(-50, 50)
	var y = Globals.rng.randf_range(-50, 50)
	var offset = Vector2(x, y)
	_explode(1.25, offset)
	
	explosion_count -= 1
	if explosion_count > 1:
		_explode_timer.start()
	else:
		_die()
