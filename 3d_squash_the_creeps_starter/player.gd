extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in metersper second squared.
@export var jump_impulse = 20
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# we create a local variable to store the input direction
	var direction = Vector3.ZERO
	
	# We check for each move input and upfate the direction accordingly.
	if Input.is_action_just_pressed("move_right"):
		direction.x += 1
	if Input.is_action_just_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_just_pressed("move_back"):
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_just_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node
		$Pivot.basis = Basis.looking_at(direction)
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor(): # if in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	#Vertical the character
	velocity = target_velocity
	move_and_slide()
	
	
