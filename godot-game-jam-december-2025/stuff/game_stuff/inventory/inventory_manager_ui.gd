extends Control

@onready var storage_grid = $Panel/MarginContainer/MainLayout/ScrollContainer/StorageGrid
@onready var loadout_container = $Panel/MarginContainer/MainLayout/LoadoutContainer
@onready var close_button = $Panel/CloseButton
@onready var popup = $ItemDetailPopup

var grid_slot_scene = preload("res://stuff/game_stuff/inventory/inventory_grid_slot.tscn")
var slot_scene = preload("res://stuff/game_stuff/inventory/inventory_slot.tscn")

func _ready():
	close_button.pressed.connect(hide)
	GameData.inventory_updated.connect(refresh_ui)
	
	popup.close_requested.connect(func(): popup.hide())
	popup.equip_requested.connect(_on_popup_equip_requested)
	popup.set_equip_mode(true) # Always equip mode in this manager
	popup.hide()
	
	_load_existing_clues() 
	refresh_ui()

func _load_existing_clues():
	var characters = ["eleanor", "rachel", "prudence", "briar"]
	var types = ["chit", "dossier"]
	
	for char_name in characters:
		for type in types:
			for i in range(1, 4):
				var path = "res://stuff/game_stuff/inventory/clues/characters/%s/%s_%d.tres" % [char_name, type, i]
				if ResourceLoader.exists(path):
					var item = load(path)
					if item:
						GameData.add_item(item)

func show_manager():
	refresh_ui()
	popup.hide()
	show()

func refresh_ui():
	# 1. Clear existing
	for child in storage_grid.get_children():
		child.queue_free()
	for child in loadout_container.get_children():
		child.queue_free()
		
	# 2. Populate Storage (Collected Items)
	var all_items = GameData.get_all_collected_items()
	for item in all_items:
		# If item is NOT equipped, show in storage
		if not GameData.has_item_equipped(item.name):
			var slot = grid_slot_scene.instantiate()
			storage_grid.add_child(slot)
			slot.set_item(item)
			
			# Connect clicked signal from Grid Slot
			slot.clicked.connect(_on_storage_item_clicked)
			
	# 3. Populate Loadout (Active 5 Slots)
	var active_items = GameData.get_inventory()
	# Always show 5 slots (empty or full)
	for i in range(5):
		var slot = slot_scene.instantiate()
		loadout_container.add_child(slot)
		
		# Ensure slot has min size?
		slot.custom_minimum_size = Vector2(80, 80) 
		
		if i < active_items.size():
			slot.set_item(active_items[i])
			slot.item_clicked.connect(func(_item): _on_loadout_item_clicked(i))
		else:
			slot.clear()

func _on_storage_item_clicked(item: InventoryItem):
	# Show Popup details
	popup.setup(item)
	popup.update_info() # Ensure visuals update
	popup.show()

func _on_popup_equip_requested(item: InventoryItem):
	# Try to equip to first available slot
	var active_count = GameData.get_inventory().size()
	if active_count < 5:
		GameData.add_item(item)
	else:
		print("Loadout full!")

func _on_loadout_item_clicked(index: int):
	# Unequip
	GameData.unequip_item_at_index(index)

