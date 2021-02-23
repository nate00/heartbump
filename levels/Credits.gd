extends Node2D

onready var sprite = $AnimatedSprite

func on_heartbeat():
	sprite.frame = 1

func on_heartbeat_end():
	sprite.frame = 0
