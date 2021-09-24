extends Node2D

var time_between
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time
var timer
var obstacle = load("res://Obstacles.tscn")
var rng = RandomNumberGenerator.new()
var tuxAlive = true
onready var obstacles = get_node("Obstacles")
# Called when the node enters the scene tree for the first time.
func _ready():
	#self.connect("tux_death", self, "on_tux_death")
	rng.randomize()
	time = 0
	time_between = rng.randi_range(5,8)
	#print(obstacles)
	$RichTextLabel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	#print(time)
	var o = obstacle.instance()
	if(time > time_between) and (tuxAlive):
		time_between = rng.randi_range(3,8)
		o.position.x = 1200
		o.position.y = 445
		time = 0
		#obstacles.add_child(o)
		get_tree().get_root().get_node("./Game/Obstacles").add_child(o)
		
	if Input.is_action_just_pressed("restart") and not tuxAlive:
		get_tree().reload_current_scene()
	


func _on_Tux_tux_death():
	print("hello")
	$Player/shadow.play("death")
	tuxAlive = false
	$RichTextLabel.visible = true
