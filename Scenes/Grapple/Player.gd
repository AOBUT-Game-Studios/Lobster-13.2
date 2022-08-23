extends KinematicBody

#experiment in creating a functional third person grapple hook system

#All camera movement will be passed to and handled by the camera node

#A good place to start is to create a system that aims to form convincing movement arcs, without
#depending on player input entirely. Essentially a grapple aim assist, that gets players to where
#they want to be more smoothly. In that case it is ideal that the trajectory of each swing seems
#fully taught, while still allowing for maneuverability. Also keeping in mind that at higher
#velocities, it may be more difficult to interact. Also it is important to keep in mind the radius
#as well, because low radius swings will relatively appear high velocity. Instead a solution could
#be to apply simple impulses at close range, as apposed to full grapple trajectories. When objects
#are too close to smoothly apply impluses, I may have to add some kind of manner of interacting
#with the object, as opposed to colliding directly with it. For example if it were a pole of some
#kind, maybe the player could do a small swing around it, and any input will determine the resulting
#impulse applied to the player. This may not work for enemies, but that's a problem for when they're
#ready.

onready var cam = get_node("Camera")
var grappling = false
var velocity = Vector3()
var speed = 10
var gravity = Vector3(0,-10,0)
var grapple_point

#Process
func _physics_process(delta):
	velocity = get_input()
	move_and_slide(velocity)
	
#Get player input's and call coresponding functions
func get_input():
	
	if grappling:
		
		if Input.is_action_just_released("Left"):
			grapple_inpulse()
		if Input.is_action_just_released("Right"):
			grapple_inpulse()
			
		if Input.is_action_just_released("RClick"):
			grapple_retract()
			return flight(Vector3())
			
		return grapple()
		
	else:
		
		var input_vector = Vector3()
		
		if Input.is_action_pressed("Forward"):
			input_vector += self.transform.basis.z
		if Input.is_action_pressed("Backward"):
			input_vector += -self.transform.basis.z
		if Input.is_action_pressed("Left"):
			input_vector += self.transform.basis.x
		if Input.is_action_pressed("Right"):
			input_vector += -self.transform.basis.x
			
		if Input.is_action_just_released("LClick"):
			attack()
		
		if Input.is_action_just_released("RClick"):
			grapple_init()
			return grapple()
		
		return flight(input_vector)
		
#Calculate and handle grappling physics
func grapple():
	pass

#Initiate grappling state
func grapple_init():
	grappling = true
	
#Detach from grapple state, restoring free movement physics
func grapple_retract():
	grappling = false
	
#Aim assist for grapple hook, and draws indicator to closest/best grapple points
func grapple_indicator():
	pass

#Draw the actual grapple hook line
func grapple_draw():
	pass

#Add an impulse to current grapple trajectory, likely to change movement direction
func grapple_inpulse():
	pass
	
#Physics calculations for non grappling state
func flight(input_vector):
	input_vector = input_vector.normalized() * speed
	input_vector += gravity
	return damp(velocity, input_vector, 10)
	
#Player melee attack
func attack():
	pass
	
#universal damp function
func damp(current, desired, damp_value):
	var damp = ((current / damp_value) * (damp_value - 1)) + (desired / damp_value)
	return damp
