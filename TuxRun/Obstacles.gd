extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed
	
	if position.x < -100:
		queue_free()


func _on_Area2D_body_entered(body):
	body._death_function()
	
	
	
