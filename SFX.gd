extends Node

export (bool) var heartbeat_only = false

export (float) var BPM = 100.0

var time = 0.0
var stopped := false

func _process(delta):
	if stopped:
		return
	
	var previous_time = time
	var previous_beat = beat(previous_time)
	
	time += delta
	var b = beat(time)
	if b > previous_beat:
		print(time)
		print(b)
		print(beats_per_sec())
		play_beat(b)

func stop():
	stopped = true

func beat(t):
	return int(t * beats_per_sec())

func play_beat(b):
	print("play " + str(b))
	if b % 4 == 0:
		play_heartbeat()
	else:
		play_hi_hat()

func play_heartbeat():
	$Heartbeat.play()
	for sub in get_tree().get_nodes_in_group("heartbeat_subs"):
		sub.on_heartbeat()
	yield(get_tree().create_timer(0.5), "timeout")
	if is_inside_tree():
		on_heartbeat_end()

func play_hi_hat():
	if heartbeat_only:
		return
	
	$HiHat.play()

func beats_per_sec():
	return BPM / 60.0

func on_heartbeat_end():
	for sub in get_tree().get_nodes_in_group("heartbeat_subs"):
		sub.on_heartbeat_end()
