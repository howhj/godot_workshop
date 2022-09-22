extends KinematicBody2D

export (int) var max_hp = 3
var _current_hp

export (int) var speed = 100

func _ready():
	_current_hp = max_hp
	
func _physics_process(delta):
	move_and_slide(Vector2(0, speed))

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func _on_Hitbox_body_entered(body):
	_current_hp -= 1
	body.queue_free()
	if _current_hp == 0:
		queue_free()

func _on_ShootTimer_timeout():
	$Manager.shoot()
