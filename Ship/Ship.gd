extends CharacterBody3D
@onready var animation_player: AnimationPlayer = find_children("*", "AnimationPlayer").front()
@onready var animation_base = animation_player.get_animation("Take 001")

## Array of the particle emitters of the main jet exhausts
var exhaust_particles
## Array of the shaded cone meshes of the 3 main jet exhausts
var exhaust_outer_meshes 
@onready var jet_particles_left = find_child("Jets_left").find_children("*", "GPUParticles3D")
@onready var jet_particles_right = find_child("Jets_right").find_children("*", "GPUParticles3D")
## forward/backward acceleration incrementor
var acceleration : float = 0.25
## Is true when the forward speed changed. Used to change jet particle visibility
var speed_changed : bool = false
## current driving speed step. Can be 0, 0.25, 0.5, 0.75 or 1
var current_speed : float = 0.0
var turn_changed = false
## Current turning angle. Will be smoothly approximated to target_turn.
var current_turn : float = 0.0
## The value current_turn will be lerped to.
var target_turn : float = 0.0
const speed_mult = 3600
## factor of rotation speed
@export_range(0.01, 1.0, 0.01) var turn_speed : float = 0.2
## current_turn will be smoothly apprimated to target_turn in turn_acceleration steps.
@export_range(0.01, 1.0, 0.01) var turn_acceleration : float = 0.1
## max. heeling radiant value to heel if turning left or right (Y-axis)
@export_range(0.01, 1.0, 0.01) var max_heeling = 0.25
## radiant value to smoothly rotate_z to ((-)max_heeling or 0.0) 
var target_heeling = 0.0
## current heeling value in radiant
var current_heeling = 0.0
## smooth steps to rotate_z to target_heeling
const heeling_acceleration = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# collect engine emitter nodes
	exhaust_particles = find_child("Exhaust_left").find_children("*", "GPUParticles3D")
	exhaust_particles = exhaust_particles + find_child("Exhaust_right").find_children("*", "GPUParticles3D")
	exhaust_particles = exhaust_particles + find_child("Exhaust_center").find_children("*", "GPUParticles3D")
	exhaust_outer_meshes = find_children("Exhaust_Outer")
	
	# init base animation
	animation_player.assigned_animation = "Take 001"
	animation_base.loop_mode = Animation.LOOP_LINEAR
	animation_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	# drive
	if speed_changed:
		for exhaust_particle: GPUParticles3D in exhaust_particles:
			exhaust_particle.speed_scale = current_speed
		for exhaust_outer_mesh: MeshInstance3D in exhaust_outer_meshes:
			exhaust_outer_mesh.visible = false if current_speed == 0.0 else true
		
	
	# turning. Start the side engines		
	if turn_changed:
		turn_changed = false
		for jet_particle_left: GPUParticles3D in jet_particles_left:
				jet_particle_left.speed_scale = 0.0
		for jet_particle_right: GPUParticles3D in jet_particles_right:
			jet_particle_right.speed_scale = 0.0
		# turn left
		if target_turn < 0.0:
			for jet_particle_left: GPUParticles3D in jet_particles_left:
				jet_particle_left.speed_scale = 1 
		# turn right
		elif target_turn > 0.0:
			for jet_particle_right: GPUParticles3D in jet_particles_right:
				jet_particle_right.speed_scale = 1 
		
	current_turn = move_toward(current_turn, target_turn, turn_acceleration * delta) 
	
	# rotate and move
	rotate_y(current_turn * delta)
	get_child(0).rotation.z = lerp_angle(get_child(0).rotation.z, target_heeling, heeling_acceleration * delta)
	velocity = speed_mult * -basis.z * current_speed * delta
	move_and_slide()

func _unhandled_input(event: InputEvent):
	speed_changed = true
	if event.is_action_pressed("forward"):
		current_speed = clamp(current_speed + acceleration, 0.0, 1.0)
	elif event.is_action_pressed("backward"):
		current_speed = clamp(current_speed - acceleration, 0.0, 1.0)
	else:
		speed_changed = false
		
	if event.is_action_pressed("left"):
		turn_changed = true
		target_turn = turn_speed
		target_heeling = -1.0 * max_heeling
	elif event.is_action_pressed("right"):
		turn_changed = true
		target_turn = -1.0 * turn_speed
		target_heeling =  max_heeling
	elif event.is_action_released("right") or event.is_action_released("left"):
		target_turn = 0.0
		target_heeling = 0.0
		turn_changed = true
	
