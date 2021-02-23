extends Node2D


signal won()
signal died()

onready var sfx = $SFX
onready var spike_wall = get_node_or_null("SpikeWall")

func on_win_start():
	if spike_wall:
		spike_wall.stop()
	sfx.heartbeat_only = true

func on_won():
	emit_signal("won")

func on_died():
	sfx.stop()
	if spike_wall:
		spike_wall.stop()
	emit_signal("died")
