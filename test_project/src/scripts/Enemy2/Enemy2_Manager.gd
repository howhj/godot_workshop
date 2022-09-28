# Read Enemy1_Manager.gd for basic information.
extends Node2D

# For Enemy2, I plan to have it alternate between two patterns: one where it
# fires 3 shots each from the left and right sides at the player, and another
# where it fires a spread of 5 shots downwards regardless of where the player
# is.
# As such, _choice is used to determine which pattern is chosen whenever
# shoot() is called.
var _choice = 0

# For the first pattern, in order to shoot 3 shots consecutively, a bit of delay
# is needed between each shot, so we will use a separate Timer to implement the
# delay and use _shots to track how many bullets have been fired already.
var _shots = 0

func shoot():
	# When _choice is 0, the first pattern (shooting 3 aimed shots from the
	# left and right) is chosen.
	if _choice == 0:
		# Start the Timer manually to track the delay between shots.
		# We do not want to autostart this Timer as we only want it to function
		# when this pattern is happening.
		$Timer.start()
		
		# Change the value of _choice so that the other pattern is used the
		# next time _shoot() is called.
		_choice = 1
		
	# If _choice is not 0, we use the second pattern (static 5-way shot down).
	else:
		# Since no Timer shenangians are needed, we call the BulletSpawner
		# directly.
		$BulletSpawnerM.shoot()
		# Remember to change the value of _choice.
		_choice = 0

# This is used to handle the delay between shots for the first pattern.
func _on_Timer_timeout():
	# Have the BulletSpawners on both sides fire a single shot.
	$BulletSpawnerL.shoot()
	$BulletSpawnerR.shoot()
	# Increment _shots.
	_shots += 1
	
	# Restart the Timer manually since it does not automatically loop.
	if _shots < 3:
		$Timer.start()
	# Once all 3 shots have been fired, we reset _shots.
	# Since we do not restart the Timer, this bullet pattern ends here.
	else:
		_shots = 0
