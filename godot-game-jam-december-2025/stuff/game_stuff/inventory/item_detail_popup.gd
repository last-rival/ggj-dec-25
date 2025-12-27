extends PanelContainer
class_name ItemDetailPanel

signal close_requested

@onready var name_label = $MarginContainer/VBoxContainer/NameLabel
@onready var desc_label = $MarginContainer/VBoxContainer/DescLabel
@onready var icon_rect = $MarginContainer/VBoxContainer/TextureRect

var current_item: InventoryItem
var allow_use: bool = true

func setup(item: InventoryItem):
	current_item = item

func _ready():
	if current_item:
		update_info()

func update_info():
	name_label.text = current_item.name
	desc_label.text = current_item.description
	
	icon_rect.visible = false

	
	if current_item.icon:
		icon_rect.texture = current_item.icon
		icon_rect.visible = true


func _on_close_button_pressed():
	close_requested.emit()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not get_global_rect().has_point(event.global_position):
			close_requested.emit()
