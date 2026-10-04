extends VehicleBody3D

const FORCE = 30.0
const DEFAULT_BRAKE = 2000.0

@onready var left: VehicleWheel3D = $Left
@onready var right: VehicleWheel3D = $Right

@onready var grab: GPUParticles3D = $Grab
@onready var drop: GPUParticles3D = $Drop
@onready var mesh_instance_3d: MeshInstance3D = $Grab/MeshInstance3D

var have_item: bool
var vacuum: bool

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if have_item:
			# TODO Drop item
			drop.emitting = true
		else:
			vacuum = true
			grab.emitting = true
			mesh_instance_3d.visible = true
	if event.is_action_released("action") and vacuum:
		vacuum = false
		grab.emitting = false
		mesh_instance_3d.visible = false

func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("right", "left", "down", "up")
	
	if input:
		left.engine_force = (input.y - input.x) * FORCE
		right.engine_force = (input.y + input.x) * FORCE
		
		left.brake = 0
		right.brake = 0
	else:
		left.engine_force = 0
		right.engine_force = 0
		
		left.brake = DEFAULT_BRAKE
		right.brake = DEFAULT_BRAKE

	if not left.is_in_contact() and not right.is_in_contact():
		print("no wheel on the ground!")
