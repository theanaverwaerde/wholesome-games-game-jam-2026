extends MeshInstance3D

func _ready() -> void:
	var sub_viewport_2 = get_tree().current_scene.get_node("%SubViewport2")
	
	var mat = mesh.surface_get_material(0) as ShaderMaterial
	
	if not mat:
		mat = material_overlay as ShaderMaterial
		
	mat.set_shader_parameter("CleanedTexture", sub_viewport_2.get_texture())
