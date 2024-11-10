extends MeshInstance3D
@export_category("Texture Animation")
@export var noise_animation_speed: Vector3 = Vector3(0.0, 0.0, 0.0)
#@export_range(0.0, 10.0, 0.01, "or_greater") var tex_noise_step: float = 0.01
#@export_range(0.0, 10.0, 0.01, "or_greater") var tex_noise_step: float = 0.01

func _ready():
	pass
	
func _process(delta):
	pass
	#var ofs = get_active_material(0).emission_texture.noise.offset
	#ofs = ofs + (noise_animation_speed * delta)
	#get_active_material(0).emission_texture.noise.offset = ofs
	#print(ofs)
	
