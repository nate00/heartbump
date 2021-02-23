extends Area2D

const SPEED = 75.0

var stopped := false

func on_body_entered(body):
	print(("entered!"))
	# body is the player
	body.take_damage()

func _physics_process(delta):
	if stopped:
		return
	
	position.x += SPEED * delta

func stop():
	stopped = true
