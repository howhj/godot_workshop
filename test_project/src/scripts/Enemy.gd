extends Node2D

export (int) var max_hp = 3
var _current_hp

var _parent
var _scroll_velocity
export (float) var custom_scale = 1

var can_shoot = false
var pre_spawn = true

func _ready():
	_current_hp = max_hp
	_parent = get_parent()
	var level = _parent.get_parent()
	_scroll_velocity = level.scroll_velocity
	var scale_value = level.scale_value
	_parent.set_scale(Vector2(scale_value, scale_value) * custom_scale)

func _physics_process(delta):
	if pre_spawn:
		_parent.move_and_slide(_scroll_velocity * delta)

func _on_VisibilityNotifier2D_screen_exited():
	_parent.queue_free()
	
func _on_Hitbox_body_entered(body):
	body.queue_free()
	_current_hp -= 1
	if _current_hp == 0:
		_parent.queue_free()

func _on_ShootTimer_timeout():
	if can_shoot:
		$Manager.shoot()

func _on_VisibilityEnabler2D_screen_entered():
	pre_spawn = false
