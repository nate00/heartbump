extends Node2D

const Title = preload("res://levels/Title.tscn")
const Tutorial = preload("res://levels/Tutorial.tscn")
const Chase = preload("res://levels/Chase.tscn")
const Platforming = preload("res://levels/Platforming.tscn")
const FlipFlop = preload("res://levels/FlipFlop.tscn")
const Credits = preload("res://levels/Credits.tscn")

export (int) var initial_level = 0
var current_level : int

const LEVELS = [
	Title,
	Tutorial, 
	Chase,
	Platforming,
	FlipFlop,
	Credits,
]

const DEATH_DURATION = 1.0
var death_elapsed
onready var death_effect = $DeathLayer/DeathEffect

func _ready():
	make_level(initial_level)

func _physics_process(delta):
	if is_dead():
		death_elapsed += delta
		if death_elapsed >= DEATH_DURATION:
			revive()

func _process(_delta):
	death_effect.visible = is_dead()

func make_level(l : int):
	clear_level()
	current_level = l
	var level = LEVELS[l].instance()
	level.connect("won", self, "on_won")
	level.connect("died", self, "on_died")
	add_child(level)

func clear_level():
	for level in get_tree().get_nodes_in_group("levels"):
		remove_child(level)

func on_won():
	call_deferred("make_level", (current_level + 1) % LEVELS.size())

func on_died():
	print("on died")
	death_elapsed = 0.0

func is_dead():
	return death_elapsed != null

func revive():
	death_elapsed = null
	make_level(current_level)
