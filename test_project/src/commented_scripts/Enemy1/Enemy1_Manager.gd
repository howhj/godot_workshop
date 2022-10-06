# Each enemy will have its own custom Manager script.
# BulletSpawners are only responsible for firing bullets, so any other
# behaviour is coded here. For example, regulating how often the BulletSpawner
# shoots, switching to a different pattern when below a certain amount of HP etc.
#
# Enemy1 is a basic popcorn enemy, so this part is extremely straightforward.
# Enemy2 and Enemy3 will have more complexity here.
extends Node2D

func shoot():
	$BulletSpawner.shoot()
