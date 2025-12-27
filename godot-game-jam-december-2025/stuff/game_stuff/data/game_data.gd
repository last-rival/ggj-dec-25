extends Node

# Constans for the game
const BRIAR_KEY = "briar"
const CHELL_KEY = "chell"
const ELEANOR_KEY = "eleanor"
const PRUDENCE_KEY = "prudence"
const RACHEL_KEY = "rachel"
const CHARACTER_SHUFFLE_CHANCE_ON_ENERGY_LEFT : int = 50;
const ALL_CHARACTERS : Array[String] = [BRIAR_KEY, CHELL_KEY, ELEANOR_KEY, PRUDENCE_KEY, RACHEL_KEY]

var character_switch_chances:Dictionary[String,int]={
	BRIAR_KEY:1,
	CHELL_KEY:1,
	ELEANOR_KEY:1,
	PRUDENCE_KEY:1,
	RACHEL_KEY:1
}

# This script represents your game data. This abstracts your data layer.
# Your game will likely be more complex than that, including file storage and load.
# To keep things simple, this example only persist the data in memory.
#

signal inventory_updated
signal collection_updated
signal energy_updated(new_amount: int)
signal energy_debug_visibility_changed(visible: bool)

var _persistence = {
	"dialogues": {},
	"global_variables": {},
	"inventory": [], # Active Loadout (Max 5)
	"collected_items": [] # All found items (Storage)
}
# Cache for faster access, updated from persistence
var inventory_items: Array[InventoryItem] = []
var collected_items_cache: Array[InventoryItem] = []
var discovered_items: Array[InventoryItem] = []

var is_expanded_inventory_open: bool = false
const MAX_ENERGY = 5
var current_energy: int = 5

var active_character:String="elanor";

func _ready():
	# --- Default UNLOCKED Items ---
	set_variable("found_body_photo", true)
	set_variable("found_priest_dossier_1", true)

	# Default Energy
	set_variable("energy", 5)
	set_variable("exhausted", false)
	set_variable("energy_debug_visible", false)

	# Character Clues
	var chars = ["eleanor", "rachel", "prudence", "briar"]
	
	for char_name in chars:
		# Dossiers (1 per char)
		var d_var = "found_%s_dossier_1" % char_name
		set_variable(d_var, false)
		
		# Chits (3 per char)
		for i in range(1, 4):
			var c_var = "found_%s_chit_%d" % [char_name, i]
			set_variable(c_var, false)

func get_variable(var_name: String):
	return _persistence.global_variables.get(var_name)


func set_variable(var_name: String, value) -> void:
	_persistence.global_variables[var_name] = value
	
	# Check for Item Discovery
	if var_name.begins_with("found_") and value == true:
		_process_discovery(var_name)

	# Check for Energy Debug Visibility
	if var_name == "energy_debug_visible":
		energy_debug_visibility_changed.emit(value)

func _process_discovery(var_name: String):
	# Find which item matches this variable
	for item in _persistence.collected_items:
		var slug = item.name.to_lower().replace(" ", "_")
		if "found_" + slug == var_name:
			if not discovered_items.has(item):
				discovered_items.append(item)
				equip_item(item) # Auto-equip logic
			return

func is_item_discovered(item_name: String) -> bool:
	var slug = item_name.to_lower().replace(" ", "_")
	var var_name = "found_" + slug
	return get_variable(var_name) == true

func is_item_used(item: InventoryItem) -> bool:
	if item.on_use_set_variable == "":
		return false
	var val = get_variable(item.on_use_set_variable)
	# Check if the variable matches the 'used' value (usually true)
	return val == item.on_use_set_value


func get_dialogue_data(dialogue_name: String):
	return _persistence.dialogues.get(dialogue_name)


func store_dialogue_data(dialogue_name: String, data: Dictionary) -> void:
	_persistence.dialogues[dialogue_name] = data


func add_item(item: InventoryItem) -> void:
	# Add to collection ONLY
	if not has_collected_item(item.name):
		_persistence.collected_items.append(item)
		collection_updated.emit()
		
		# Check if this item is already discovered (variable set before load)
		if is_item_discovered(item.name):
			if not discovered_items.has(item):
				discovered_items.append(item)
				equip_item(item)

func equip_item(item: InventoryItem) -> bool:
	# Check if already equipped
	if has_item_equipped(item.name):
		return false
		
	# Check if space available
	if _persistence.inventory.size() < 5:
		_persistence.inventory.append(item)
		set_variable(item.use_condition_variable,true)
		inventory_updated.emit()
		return true
	
	return false

func remove_item_from_active(item: InventoryItem) -> void:
	if _persistence.inventory.has(item):
		_persistence.inventory.erase(item)
		set_variable(item.use_condition_variable,false)
		inventory_updated.emit()

func has_collected_item(item_name: String) -> bool:
	for item in _persistence.collected_items:
		if item.name == item_name:
			return true
	return false

func get_all_collected_items() -> Array:
	return _persistence.collected_items

func has_item_equipped(item_name: String) -> bool:
	for item in _persistence.inventory:
		if item.name == item_name:
			return true
	return false

func has_item(item_name: String) -> bool:
	for item in _persistence.inventory:
		if item.name == item_name:
			return true
	return false

func get_inventory() -> Array:
	return _persistence.inventory

func modify_energy(amount: int) -> void:
	current_energy = clamp(current_energy + amount, 0, MAX_ENERGY)
	
	# Sync to global variables for dialogue system
	set_variable("energy", current_energy)
	
	# Check exhaustion
	if current_energy == 0:
		set_variable("exhausted", true)
		print("Player is exhausted!")
	else:
		set_variable("exhausted", false)

	energy_updated.emit(current_energy)

func set_energy(amount: int) -> void:
	current_energy = clamp(amount, 0, MAX_ENERGY)
	
	set_variable("energy", current_energy)
	
	if current_energy == 0:
		set_variable("exhausted", true)
	else:
		set_variable("exhausted", false)
		
	energy_updated.emit(current_energy)
