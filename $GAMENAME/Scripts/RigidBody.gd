extends RigidBody


var thrown = false
export var damage = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	if true :
		#print("Rigid Object fell on floor")
		thrown = false
		#need to add area collisions to all floor/wall/ceiling type objects to 
		#reset thrown to false
