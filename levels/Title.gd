extends Node2D

signal won()

onready var sprite = $AnimatedSprite

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		emit_signal("won")

func on_heartbeat():
	sprite.frame = 1

func on_heartbeat_end():
	sprite.frame = 0
