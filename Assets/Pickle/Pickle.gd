extends MeshInstance3D
@export var rotation_speed: Vector3 = Vector3(0.1333, 0.32, 0.0783)

func _physics_process(delta):
	rotate_x(rotation_speed.x * delta)
	rotate_y(rotation_speed.y * delta)
	rotate_z(rotation_speed.z * delta)
