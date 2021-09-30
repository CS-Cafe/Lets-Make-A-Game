##TO DO LIST
#Adjust Flashlight Size/Intensity



extends KinematicBody

const gravity = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 4.5

var dir = Vector3()

const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

export var MOUSE_SENSITIVITY = 0.05

func _ready():
	camera = $rotation_helper/player_camera
	rotation_helper = $rotation_helper
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	process_inputs(delta)
	process_movement(delta)
	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y*MOUSE_SENSITIVITY * -1)) #chagne to 1 for inverted mouse up/dwn
		self.rotate_y(deg2rad(event.relative.x*MOUSE_SENSITIVITY * -1)) #change to 1 for inverted mouse left/right
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
		
func process_inputs(delta):
		if is_on_floor(): #keeps motion while in jump
			dir = Vector3() 
		var cam_xform = camera.get_global_transform()
		
		var input_movement_vector = Vector2()
		
		if Input.is_action_pressed("movement_forward") and is_on_floor():
			input_movement_vector.y += 1
		if Input.is_action_pressed("movement_backward") and is_on_floor():
			input_movement_vector.y -= 1
		if Input.is_action_pressed("movement_left") and is_on_floor():
			input_movement_vector.x -= 1
		if Input.is_action_pressed("movement_right") and is_on_floor():
			input_movement_vector.x += 1
		
		input_movement_vector = input_movement_vector.normalized()
		
		dir += -cam_xform.basis.z * input_movement_vector.y
		dir += cam_xform.basis.x * input_movement_vector.x
		
		#Jump
		if is_on_floor():
			if Input.is_action_just_pressed("movement_jump"):
				vel.y = JUMP_SPEED
			
			
		#add in cursor freeing
		if Input.is_action_just_pressed("ui_cancel"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		#Flashlight Toggle
		if Input.is_action_just_pressed("player_flashlight"):
			var flashlight = $rotation_helper/player_flashlight
			if flashlight.visible == true:
				flashlight.visible = false
			else:
				flashlight.visible = true
			


func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta * gravity
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
		
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	
