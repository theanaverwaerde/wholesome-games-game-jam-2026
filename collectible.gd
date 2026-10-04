extends RigidBody3D
class_name Collectible

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum ItemType {PLAYER,K7,EARBUDS}

@export var item_type: ItemType

func _ready() -> void:
	animation_player.play("item_anim")
	
