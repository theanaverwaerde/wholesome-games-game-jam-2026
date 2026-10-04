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

@onready var moving_sound_left: AudioStreamPlayer3D = $Left/MovingSoundLeft
@onready var moving_sound_right: AudioStreamPlayer3D = $Right/MovingSoundRight
@onready var aspiring: AudioStreamPlayer = $Aspiring
@onready var collectible: AudioStreamPlayer = $Collectible

var vacuum: bool
var in_hq: bool

var items_area: Array[Collectible]
var items_in:  Array[Collectible]

signal get_item(item: Collectible)
signal drop_item(item: Collectible)

func _ready() -> void:
	moving_sound_left.play()
	moving_sound_left.volume_db = -80
	moving_sound_right.play()
	moving_sound_right.volume_db = -80

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if items_in.size() > 0 and in_hq:
			var i = items_in.pop_back()
			i.global_position = global_position + -transform.basis.z * .6
			i.drop_vacuum()
			drop_item.emit(i)
			i.apply_force(-transform.basis.z * DROP_FORCE)
			drop.emitting = true
		else:
			vacuum = true
			grab.emitting = true
			mesh_instance_3d.visible = true
			aspiring.play()
			
			
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
	
	if left.engine_force >= 0:
		moving_sound_left.volume_db = lerp(-80,0,minf(left.engine_force/FORCE, 1))
	else:
		moving_sound_left.volume_db = lerp(-80,-20,minf(-left.engine_force/FORCE, 1))
	
	if right.engine_force >= 0:
		moving_sound_right.volume_db = lerp(-80,0,minf(right.engine_force/FORCE, 1))
	else:
		moving_sound_right.volume_db = lerp(-80,-20,minf(-right.engine_force/FORCE, 1))
	
	if not left.is_in_contact() and not right.is_in_contact():
		print("no wheel on the ground!")
	
	if vacuum:
		for i in items_area:
			if global_position.distance_to(i.global_position) < .6:
				items_in.append(i)
				i.in_vacuum()
				get_item.emit(i)
				collectible.play()
			else:
				i.apply_force((global_position - i.global_position).normalized() * VACUUM_FORCE)

func vacuum_stop() -> void:
	vacuum = false
	grab.emitting = false
	mesh_instance_3d.visible = false
	aspiring.stop()

func _on_area_3d_body_entered(body: Node3D) -> void:
	items_area.append(body as Collectible)

func _on_area_3d_body_exited(body: Node3D) -> void:
	items_area.remove_at(items_area.find(body))

func _on_hq_entered(body: Node3D) -> void:
	if body == self:
		in_hq = true
		return

func _on_hq_exited(body: Node3D) -> void:
	if body == self:
		in_hq = false
		return
