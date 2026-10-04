extends RigidBody3D
class_name Collectible

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum ItemType {PLAYER,K7,EARBUDS}

@export var item_type: ItemType

func _ready() -> void:
	animation_player.play("item_anim")
	
func in_vacuum():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	
func drop_vacuum():
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	
func in_hq():
	collision_layer = 0
