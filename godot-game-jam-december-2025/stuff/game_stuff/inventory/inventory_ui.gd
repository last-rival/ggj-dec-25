extends Control

@onready var slots_container = $MarginContainer/HBoxContainer
var item_popup_scene = preload("res://stuff/game_stuff/inventory/item_detail_popup.tscn")

var current_popup: Node

func _ready():
	GameData.inventory_updated.connect(update_ui)
	
	# Connect slots
	for slot in slots_container.get_children():
		slot.item_clicked.connect(_on_slot_clicked)
	
	update_ui()

func update_ui():
	var items = GameData.get_inventory()
	for i in range(5):
		if i < slots_container.get_child_count():
			var slot = slots_container.get_child(i)
			if i < items.size():
				slot.set_item(items[i])
			else:
				slot.clear()

func _on_slot_clicked(item: InventoryItem):
	if GameData.is_expanded_inventory_open:
		GameData.remove_item_from_active(item)
		return

	if current_popup:
		current_popup.queue_free()
		
	var popup = item_popup_scene.instantiate()
	popup.setup(item)
	popup.close_requested.connect(_on_popup_closed)
	add_child(popup)
	current_popup = popup

func _on_popup_closed():
	if current_popup:
		current_popup.queue_free()
		current_popup = null
