extends Control
class_name ItemInventory

@onready var grid_container = $Panel/ScrollContainer/GridContainer
@export var popup : ItemDetailPanel

var slot_scene = preload("res://stuff/game_stuff/inventory/inventory_slot.tscn")

func _ready():
	popup.hide()
	popup.close_requested.connect(func(): popup.hide())

	# Refresh grid when inventory changes (e.g. item used/removed)
	GameData.inventory_updated.connect(func(): if visible: refresh())

func refresh():
	# Clear existing
	for child in grid_container.get_children():
		child.queue_free()

	# Get discovered items in order of discovery
	var items = GameData.discovered_items
	
	var item_count = items.size();

	for i in range(item_count):
		var item = items[i]
		
		if item == null || item.name == "":
			continue;

		var slot = slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.item_clicked.connect(_on_slot_clicked)
		slot.set_item(item)
		slot.show_bg_visible(true)

func _on_slot_clicked(item: InventoryItem):
	# Ignore inventory interactions in the grid
	#popup.allow_use = false
	popup.setup(item)
	popup.update_info() # Ensure visuals update logic is triggered
	popup.show()
	GameData.equip_item(item);
	return;
