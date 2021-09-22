extends Node2D

var time_between
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time
var timer
var obstacle = load("res://Obstacles.tscn")
var rng = RandomNumberGenerator.new()

onready var obstacles = get_node("Game/Obstacles")
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	time = 0
	time_between = rng.randi_range(5,8)
	print(obstacles)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	print(time)
	var o = obstacle.instance()
	if(time > time_between):
		time_between = rng.randi_range(3,8)
		o.position.x = 1200
		o.position.y = 420
		time = 0
		add_child(o)
