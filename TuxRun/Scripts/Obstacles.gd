extends StaticBody2D

export var speed = 3

func _ready():
	pass

func _process(delta):
	position.x -= speed
	if position.x < -100:
		queue_free()

func _on_Area2D_body_entered(body):
	body._death_function()
