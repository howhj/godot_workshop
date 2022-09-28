# Read Enemy1_Manager.gd and Enemy2_Manager.gd for pre-requisite information.
extends Node2D

# Like Enemy2, Enemy3 is going to use 2 different patterns, but they will be
# used at the same time.
#
# The first pattern is 5 continuous streams of bullets that will continuously
# rotate, which is what we use the variables below for. rot_speed controls how
# quickly the streams rotate, while _offset is used to track the angular offset
# due to the rotation.
#
# The second pattern is a flower-shaped burst in all directions, where its
# rotation is dependent on the player's position (making this an aimed pattern).
#
# A single BulletSpawner is used for both patterns, since they both originate
# from the center of the enemy.
export (int) var rot_speed = 2
var _offset = 0

# The first pattern is continuously fired, so only the second pattern has to be
# regulated by the ShootTimer.
func shoot():
	$BulletSpawner.shoot_flower()

# Like Enemy2, a separate Timer is used to provide a short delay between bullets
# for the continuous streams.
func _on_Timer_timeout():
	$BulletSpawner.shoot_lines(_offset)
	# _offset is increased whenever a new set of bullets is fired.
	_offset += rot_speed % 360
