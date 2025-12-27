extends Control
@onready var grid_container = $GridContainer
@onready var popup = $ItemDetailPopup

var slot_scene = preload("res://stuff/game_stuff/inventory/inventory_slot.tscn")
const GRID_SIZE = 30 # 6 columns * 5 rows

var _populated = false

func _ready():
	hide() # Ensure hidden on start
	popup.hide()
	popup.close_requested.connect(func(): popup.hide())
	
	# Refresh grid when inventory changes (e.g. item used/removed)
	GameData.inventory_updated.connect(func(): if visible: _populate_grid())

func open():
	_populate_grid()
	show()
	GameData.is_expanded_inventory_open = true

func close():
	hide()
	popup.hide()
	GameData.is_expanded_inventory_open = false

func toggle():
	if visible:
		close()
	else:
		open()

func _populate_grid():
	# Clear existing
	for child in grid_container.get_children():
		child.queue_free()

	# Get discovered items in order of discovery
	var items = GameData.discovered_items
	
	var item_count = items.size();

	for i in range(item_count):
		var slot = slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.item_clicked.connect(_on_slot_clicked)
		
		if i < item_count:
			var item = items[i]
			slot.set_item(item)
			slot.show_bg_visible(true)
			
			# Check if used
			if GameData.is_item_used(item):
				slot.set_used_state(true)
			else:
				slot.set_used_state(false)
		else:
			slot.clear() # Empty slot

func _on_slot_clicked(item: InventoryItem):
	# Ignore inventory interactions in the grid
	#popup.allow_use = false
	#popup.setup(item)
	#popup.update_info() # Ensure visuals update logic is triggered
	#popup.show()
	GameData.equip_item(item);
	return;
