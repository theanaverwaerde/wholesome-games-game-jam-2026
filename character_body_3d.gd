extends VehicleBody3D

const FORCE = 30.0
const DEFAULT_BRAKE = 2000.0

@onready var left: VehicleWheel3D = $Left
@onready var right: VehicleWheel3D = $Right

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
