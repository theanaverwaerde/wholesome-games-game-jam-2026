extends Node
class_name GameManager

@onready var earbuds: TextureRect = %UIEarbuds
@onready var player: TextureRect = %UIPlayer
@onready var k7: TextureRect = %UIK7

@onready var move_tuto: Label = $MoveTuto
@onready var vacumm_tuto: Label = $VacummTuto
@onready var drop_tuto: Label = $DropTuto

func _ui_item(item: Collectible.ItemType) -> TextureRect: 
	match item:
		Collectible.ItemType.PLAYER:
			return player
		Collectible.ItemType.K7:
			return k7
		Collectible.ItemType.EARBUDS:
			return earbuds
	return null

var in_hq: Array[Collectible.ItemType]

func _set_ui_value(item: Collectible.ItemType, value: float):
	var mat = _ui_item(item).material as ShaderMaterial
	mat.set_shader_parameter("GrayScalePercent", value)

func _on_player_get_item(item: Collectible) -> void:
	if item.item_type not in in_hq:
		_set_ui_value(item.item_type,.5)

func _on_player_drop_item(item: Collectible) -> void:
	if item.item_type not in in_hq:
		_set_ui_value(item.item_type,1)

func get_hq_item(item: Collectible.ItemType):
	_set_ui_value(item,0)

func _on_hq_body_entered(body: Node3D) -> void:
	if body is Collectible:
		var c = body as Collectible
		if c.item_type not in in_hq:
			get_hq_item(c.item_type)
			in_hq.append(c.item_type)
			c.in_hq()
			if in_hq.size() == 3:
				win()
	elif body == %Player:
		drop_tuto.visible = true

func win():
	if not Music.playing:
		Music.play()
		await get_tree().create_timer(5).timeout
		# TODO black fade out animation
		get_tree().change_scene_to_file("res://end1.tscn")

func _on_first_room_body_exited(body: Node3D) -> void:
	if body == %Player:
		move_tuto.visible = false
		vacumm_tuto.visible = false
		drop_tuto.visible = false


func _on_hq_body_exited(body: Node3D) -> void:
	if body == %Player:
		drop_tuto.visible = false
