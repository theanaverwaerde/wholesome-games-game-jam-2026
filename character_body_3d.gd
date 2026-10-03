extends VehicleBody3D

const FORCE = 100.0

@onready var left: VehicleWheel3D = $Left
@onready var right: VehicleWheel3D = $Right

func _physics_process(_delta: float) -> void:
	var forward_input := Input.get_axis("down", "up")
	var turn_input := Input.get_axis("right", "left")
	
	left.engine_force = (forward_input - turn_input) * FORCE
	right.engine_force = (forward_input + turn_input) * FORCE

	if not left.is_in_contact() and not right.is_in_contact():
		print("no wheel on the ground!")
