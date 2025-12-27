extends Node2D
class_name BreakRoom

signal exit_break_room;
@onready var popup : ItemDetailPanel = $break_room/ItemDetailPopup
@onready var inventory : ItemInventory  = $break_room/ExpandedInventoryUI
@onready var items_visuals : Node2D = $bg/items

func _ready() -> void:
	popup.close_requested.connect(hide_popup)

func _on_exit_room_pressed() -> void:
	exit_break_room.emit();

func set_up():
	popup.hide()
	inventory.refresh();
	update_item_visuals()
	GameData.is_expanded_inventory_open = true

func close():
	GameData.is_expanded_inventory_open = false

func hide_popup():
	popup.hide();

func update_item_visuals():
	var item_list = GameData.discovered_items
	for item in item_list:
		var item_node=items_visuals.get_node(item.get_item_id())
		if item_node:
			var childCount = item_node.get_child_count();
			if childCount == 0:
				item_node.show();
			if childCount >=1:
				item_node.get_child(0).show();
			if childCount == 2:
				item_node.get_child(1).hide();
