##TO DO LIST
#Adjust Flashlight Size/Intensity



extends KinematicBody

#Basic Movement
const ACCEL = 4.5
const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40
const MAX_SPEED = 15
var vel = Vector3()
var dir = Vector3()

#Jump Movement
const JUMP_SPEED = 9
const gravity = -24.8

#Sprint Movement
var is_sprinting = false
var MAX_SPRINT_SPEED = 20
var SPRINT_ACCEL = 18

#Flashlight
var flashlight

#Camera
var camera
export var x_range = 70

#Grabbing RigidBodys
var grabbed_object = null
#const OBJECT_THROW_FORCE = 120
#const OBJECT_GRAB_DISTANCE = 7
#const OBJECT_GRAB_RAY_DISTANCE = 10
export var OBJECT_THROW_FORCE = 120
export var OBJECT_GRAB_DISTANCE = 7
export var OBJECT_GRAB_RAY_DISTANCE = 10
var object_detection
var object_detection_collision

#Rotation Helper
var rotation_helper
export var MOUSE_SENSITIVITY = 0.05

#UI
var reticle

func _ready():
	#Camera
	camera = $rotation_helper/player_camera
	
	#Rotation Helper
	rotation_helper = $rotation_helper
	
	#Flashlight
	flashlight = $rotation_helper/player_flashlight
	
	#UI
	reticle = $player_hud/Reticle
	reticle.set_position(get_viewport().size / 2)
	#Change Var for Color Shift
	reticle = $player_hud/Reticle/ColorRect
	
	#Grabbing Objects
	object_detection = $rotation_helper/gun_fire_points
	object_detection_collision = $rotation_helper/gun_fire_points/grab_objects/Area/CollisionShape
	if true:
		#Set Area to Grab Distance
		object_detection.translation = Vector3(0,0,OBJECT_GRAB_RAY_DISTANCE / 2 * -1)
		object_detection_collision.get_shape().set_extents(Vector3(.05,.05,OBJECT_GRAB_RAY_DISTANCE / 2))
		
	
	#Initial Mouse Mode
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	process_inputs(delta)
	process_movement(delta)
	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y*MOUSE_SENSITIVITY * -1)) #chagne to 1 for inverted mouse up/dwn
		self.rotate_y(deg2rad(event.relative.x*MOUSE_SENSITIVITY * -1)) #change to 1 for inverted mouse left/right
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -x_range, x_range)
		rotation_helper.rotation_degrees = camera_rot
		
func process_inputs(delta):
		#Check if Jumping
		if is_on_floor(): #keeps motion while in jump
			dir = Vector3() 
		#Camera Transform
		var cam_xform = camera.get_global_transform()
		
		#Set Input Movement
		var input_movement_vector = Vector2()
		
		#Basic Movement
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
		
		#Jump Movement
		if is_on_floor():
			if Input.is_action_just_pressed("movement_jump"):
				vel.y = JUMP_SPEED
			
			
		#Cursor Freeing
		if Input.is_action_just_pressed("ui_cancel"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		#Flashlight Toggle
		if Input.is_action_just_pressed("player_flashlight"):
			#var flashlight = $rotation_helper/player_flashlight
			if flashlight.visible == true:
				flashlight.visible = false
			else:
				flashlight.visible = true
		
		#Sprinting Movement
		if Input.is_action_pressed("movement_sprint"):
			is_sprinting = true
		else:
			is_sprinting = false
			
		#Grabbing RigidBody's
		if Input.is_action_just_pressed("fire_grenade"): # and current_weapon == "UNARMED": #For Use in True FPS
			if grabbed_object == null:
				var state = get_world().direct_space_state
				var center_position = get_viewport().size / 2
				var ray_from = camera.project_ray_origin(center_position)
				var ray_to = ray_from + camera.project_ray_normal(center_position) * OBJECT_GRAB_RAY_DISTANCE
				
				var ray_result = state.intersect_ray(ray_from, ray_to, [self, $rotation_helper/gun_fire_points/grab_objects/Area])
				if !ray_result.empty():
					if ray_result["collider"] is RigidBody:
						grabbed_object = ray_result["collider"]
						grabbed_object.mode = RigidBody.MODE_STATIC
						grabbed_object.collision_layer = 0
						grabbed_object.collision_mask = 0
						
						
			else:
				grabbed_object.mode = RigidBody.MODE_RIGID
				grabbed_object.apply_impulse(Vector3(0,0,0), -camera.global_transform.basis.z.normalized()*OBJECT_THROW_FORCE)
				grabbed_object.collision_layer = 1
				grabbed_object.collision_mask = 1
				grabbed_object.thrown = true #Object has been thrown
				
				grabbed_object = null
		if grabbed_object != null:
			grabbed_object.global_transform.origin = camera.global_transform.origin + (-camera.global_transform.basis.z.normalized() * OBJECT_GRAB_DISTANCE)

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta * gravity
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	#target *= MAX_SPEED
	if is_sprinting:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		if is_sprinting:
			accel = SPRINT_ACCEL
		else:
			accel = ACCEL
	else:
		accel = DEACCEL
		
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	

#Considering Highlighting Objects or Highlighting/Changing HUD Reticle
func _on_Area_body_entered(body):
	#Highlight RigidBody
	if body is RigidBody:
	#	var CSGSPHERE : Node = body.get_node("CSGSphere")
	#	CSGSPHERE.material_override = load("res://Shaders_and_Materials/plain_white_material_outline.tres")
	#	#print(CSGSPHERE)
		reticle.color = Color(0,1,0,1)
	pass

func _on_Area_body_exited(body):
	#Remove Highlight on RigidBody
	if body is RigidBody:
	#	var CSGSPHERE : Node = body.get_node("CSGSphere")
	#	CSGSPHERE.material_override = load("res://Shaders_and_Materials/plain_white_material.tres")
	#	#print(CSGSPHERE)
		reticle.color = Color(1,1,1,1)
	pass
	pass # Replace with function body.


func _on_damage_area_body_entered(body):
	if body is RigidBody and body.damage != null and body.thrown == true:
		pass
