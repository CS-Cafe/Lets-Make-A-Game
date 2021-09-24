extends KinematicBody2D

export var gravity = 32
export var jumpforce = 1000
var motion = Vector2.ZERO 

signal tux_death

func _physics_process(delta): 
	motion.x = 0
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -jumpforce
		if Input.is_action_pressed("crouch"):
			pass #crouching mechanics here
	motion.y += gravity + delta
	motion = move_and_slide(motion, Vector2.UP)

func _death_function():
	emit_signal("tux_death")
	$AnimatedSprite.play("death")
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	timer.wait_time = 3
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	queue_free()
