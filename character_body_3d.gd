extends VehicleBody3D

const FORCE = 30.0
const VACUUM_FORCE = 30.0
const DROP_FORCE = 1000.0
const DEFAULT_BRAKE = 2000.0

@onready var left: VehicleWheel3D = $Left
@onready var right: VehicleWheel3D = $Right

@onready var grab: GPUParticles3D = $Grab
@onready var drop: GPUParticles3D = $Drop
@onready var mesh_instance_3d: MeshInstance3D = $Grab/MeshInstance3D

var vacuum: bool

var items_area: Array[Collectible]
var item_in: Collectible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if item_in != null:
			item_in.global_position = global_position + -transform.basis.z * .6
			item_in.visible = true
			item_in.apply_force(-transform.basis.z * DROP_FORCE)
			item_in = null
			drop.emitting = true
		else:
			vacuum = true
			grab.emitting = true
			mesh_instance_3d.visible = true
	if event.is_action_released("action") and vacuum:
		vacuum_stop()

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
	
	if vacuum:
		for i in items_area:
			if global_position.distance_to(i.global_position) < .6:
				item_in = i
				i.visible = false
				print("in: " + i.name)
				vacuum_stop()
				return
			else:
				print((global_position - i.global_position).normalized())
				i.apply_force((global_position - i.global_position).normalized() * VACUUM_FORCE)

func vacuum_stop() -> void:
	vacuum = false
	grab.emitting = false
	mesh_instance_3d.visible = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("enter")
	print(body.name)
	items_area.append(body as Collectible)


func _on_area_3d_body_exited(body: Node3D) -> void:
	print("exit")
	print(body.name)
	items_area.remove_at(items_area.find(body))
