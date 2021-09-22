extends Node2D

var time_between
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time
var timer
var obstacle = load("res://Obstacles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	time = 0
	time_between = 3
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	print(time)
	var o = obstacle.instance()
	if(time_between > 2) and time > time_between:
		time_between = time_between-1
		# o.speed = (1 / time_between) * 10
		o.position.x = 1200
		o.position.y = 420
		time = 0
		add_child(o)
	elif (time > time_between):
		o.position.x = 1200
		o.position.y = 420
		#o.speed = 6
		time = 0
		add_child(o)
	
