extends Camera3D
@export var target: Node3D
@export var offset : Vector3 = Vector3(0, 80.0, 110.0)
@export_range(0.0, 10.0) var smooth: float = 0.1
var look_at: Vector3 = Vector3(0,0,0)

func _ready():
	global_transform = target.global_transform.translated_local(offset*10)
	
func _physics_process(delta):
	var target_xform = target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_xform, smooth * delta)
