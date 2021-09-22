extends KinematicBody2D # The player is a kinematic body, hence extends Kine..

# Adjustable variables of the player
# export is used to allow to edit the values outside the script
export var speed = 700 # The speed of the character
export var gravity = 32 # The gravity of the character
export var jumpforce = 1000 # The jump force of the character

var motion = Vector2.ZERO 

func _physics_process(delta): 
	motion.x = 0
	if is_on_floor(): # If the ground checker is colliding with the ground
		if Input.is_action_just_pressed("jump"): # And the player hits the up arrow key
			#JumpSound.play() # Play the jump sound
			motion.y = -jumpforce # then jump by jumpforce
		if Input.is_action_pressed("crouch"):
			pass #crouching mechanics here
	
	motion.y += gravity + delta # Always make the player fall down
	
	motion = move_and_slide(motion, Vector2.UP)
	# Move and slide is a function which allows the kinematic body to detect
	# collisions and move accordingly
