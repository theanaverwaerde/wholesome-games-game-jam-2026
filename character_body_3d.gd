extends RigidBody3D

const SPEED = 4.0
const ROTATE_SPEED = 10.0

func _integrate_forces(state):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := transform.basis * Vector3(0, 0, input_dir.y)
	if direction:
		state.set_linear_velocity(direction * SPEED)
	if input_dir.x:
		state.set_angular_velocity(Vector3.UP * (-input_dir.x * ROTATE_SPEED))
