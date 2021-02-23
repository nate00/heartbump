extends Area2D

onready var sprite = $Sprite

func on_body_entered(body):
	print(("entered!"))
	# body is the player
	body.take_damage()

func on_heartbeat():
	sprite.scale = Vector2(1.25, 1.25)

func on_heartbeat_end():
	sprite.scale = Vector2(1.0, 1.0)
