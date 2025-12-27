extends Node2D

signal exit_break_room;

func _ready() -> void:
	# Connect Inventory Button
	$break_room/InventoryButton.pressed.connect(func(): $break_room/ExpandedInventoryUI.toggle())

	# Handle visibility
	GameData.inventory_visibility_changed.connect(func(v): $break_room/InventoryButton.visible = v)
	# Set initial state (default true if not set)
	var is_inv_visible = GameData.get_variable("inventory_button_visible")
	if is_inv_visible == null: is_inv_visible = true
	$break_room/InventoryButton.visible = is_inv_visible

func _on_exit_room_pressed() -> void:
	exit_break_room.emit();
