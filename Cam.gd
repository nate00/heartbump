extends Camera2D

onready var player = $"../Player"

const PLAYER_OFFSET = 64.0

func _process(_delta):
	position.x = player.position.x - PLAYER_OFFSET
