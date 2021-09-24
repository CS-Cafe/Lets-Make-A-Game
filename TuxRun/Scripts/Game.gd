extends Node2D

var time_between
var time
var timer
var obstacle = load("res://Scenes/Obstacles.tscn")
var rng = RandomNumberGenerator.new()
var tuxAlive = true
onready var obstacles = get_node("Obstacles")

func _ready():
	rng.randomize()
	time = 0
	time_between = rng.randi_range(5,8)
	$RichTextLabel.visible = false

func _process(delta):
	time += delta
	var o = obstacle.instance()
	if(time > time_between) and (tuxAlive):
		time_between = rng.randi_range(3,8)
		o.position.x = 1200
		o.position.y = 445
		time = 0
		get_tree().get_root().get_node("./Game/Obstacles").add_child(o)
	if Input.is_action_just_pressed("restart") and not tuxAlive:
		get_tree().reload_current_scene()

func _on_Tux_tux_death():
	print("hello")
	$Player/shadow.play("death")
	timer.connect("timeout",self,"_on_timer_timeout") 
	timer.wait_time = 3
	add_child(timer)
	timer.start()
	$RichTextLabel.visible = true	

func _on_timer_timeout():
	tuxAlive = false
