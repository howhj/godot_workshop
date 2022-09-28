# This is a generic script that all enemies are going to use.
# I will skip over anything that has been mentioned in Player.gd.
extends KinematicBody2D

# We want to export this variable as it is the only way to give enemies
# different HP values despite all of them using this script.
export (int) var max_hp = 3
var _current_hp

# Same as above. This is used to dictate the enemy's speed.
export (int) var speed = 100

func _ready():
	_current_hp = max_hp

# Allows the enemy to move. For now, we have them drift downward.
func _physics_process(delta):
	move_and_slide(Vector2(0, speed))

# The following functions are built-in. Note the icons beside the line numbers.
# These functions are connected to child nodes, and they are called whenever
# a particular signal is received from that node. See the week 2 recap PDF for
# more information.
#
# In this case, the child node is VisibilityNotifier2D, while the signal is
# screen_exited. In other words, this object is destroyed when it leaves the
# screen.
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
# Here, the child node is Hitbox (which is an Area2D node), while the signal
# is body_entered. The Area2D node detects if a body (e.g. KinematicBody2D)
# has entered it, and emits this signal if it did.
# In this context, the enemy hitbox detects if it has collided with a player
# bullet, and decreases its HP by 1 if it did.
#
# body is the other object that entered the Area2D, and due to how the
# physics layers are configured, it will only be a player bullet.
func _on_Hitbox_body_entered(body):
	_current_hp -= 1
	
	# Since an Area2D isn't exactly a solid collider like a KinematicBody2D,
	# the player bullet will not detect a collision. As such, we destroy the
	# player bullet from here instead.
	body.queue_free()
	
	# This simply destroys the enemy when its HP reaches 0.
	if _current_hp == 0:
		queue_free()

# Here, the child node is ShootTimer (which is a Timer node). The signal is
# timeout.
# Timers count down from whatever value is specified. When it reaches 0, the
# timeout signal is emitted.
# Here, we use it to call the Manager child node (which is a Node2D with a
# script) to use the shoot() function whenever the ShootTimer reaches 0.
#
# The reason for setting up a Manager is to give a common interface between
# all enemies. It is much easier to create complex bullet patterns by using
# multiple BulletSpawners, using Timers, alternating between bullet patterns
# etc., all of which are highly customised behaviours. To avoid boilerplate
# code, we have the common properties across all enemies coded here, while
# custom code like bullet patterns are done in separate scripts.
#
# So, as long as we create a child node named Manager for each enemy, and that
# the Manager has a script with a shoot() function defined, we can trigger
# custom behaviour from a generic script like this.
func _on_ShootTimer_timeout():
	$Manager.shoot()
