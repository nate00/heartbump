extends StaticBody2D

func on_heartbeat():
	$Sprite.scale = Vector2(1.3, 1.3)

func on_heartbeat_end():
	$Sprite.scale = Vector2(1.0, 1.0)
