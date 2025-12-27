extends Node2D
class_name BreakRoom

signal exit_break_room;
@onready var popup : ItemDetailPanel = $break_room/ItemDetailPopup
@onready var inventory : ItemInventory  = $break_room/ExpandedInventoryUI

func _ready() -> void:
	popup.close_requested.connect(hide_popup)

func _on_exit_room_pressed() -> void:
	exit_break_room.emit();


func set_up():
	popup.hide()
	inventory.refresh();
	GameData.is_expanded_inventory_open = true

func close():
	GameData.is_expanded_inventory_open = false

func hide_popup():
	popup.hide();
