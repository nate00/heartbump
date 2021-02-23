extends Area2D

signal won()
signal on_win_start()

const WIN_DURATION = 3.0
const WIN_SCALE_RATE = 4.0
# Becomes non-null after winning.
var win_duration_elapsed

func _process(delta):
	if did_win():
		win_duration_elapsed += delta
		var scale_factor = scale.x - 1
		scale_factor = WIN_SCALE_RATE * pow(win_duration_elapsed, 2) - scale_factor
		self.scale = Vector2(1,1) * (1 + scale_factor)
		if win_duration_elapsed >= WIN_DURATION:
			emit_signal("won")
			win_duration_elapsed = null

func on_heartbeat():
	if !did_win():
		$Sprite.scale = Vector2(1.3, 1.3)

func on_heartbeat_end():
	if !did_win():
		$Sprite.scale = Vector2(1.0, 1.0)

func did_win() -> bool:
	return win_duration_elapsed != null

func on_body_entered(body):
	if !did_win():
		body.on_won(self)
		z_index = 1
		win_duration_elapsed = 0.0
		emit_signal("on_win_start")
