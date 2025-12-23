extends Node

# This script represents your game data. This abstracts your data layer.
# Your game will likely be more complex than that, including file storage and load.
# To keep things simple, this example only persist the data in memory.
#

signal inventory_updated



var _persistence = {
	"dialogues": {},
	"global_variables": {},
	"inventory": [] # Array of InventoryItem
}
# Cache for faster access, updated from persistence
var inventory_items: Array[InventoryItem] = []


func get_variable(var_name: String):
	# this is an example of a dynamic value which is not part of the game persistence
	# this is abstracted from the dialogue system
	if var_name == "hour_of_day":
		return Time.get_time_dict_from_system().hour

	return _persistence.global_variables.get(var_name)


func set_variable(var_name: String, value) -> void:
	_persistence.global_variables[var_name] = value


func get_dialogue_data(dialogue_name: String):
	return _persistence.dialogues.get(dialogue_name)


func store_dialogue_data(dialogue_name: String, data: Dictionary) -> void:
	_persistence.dialogues[dialogue_name] = data


func add_item(item: InventoryItem) -> void:
	if _persistence.inventory.size() < 5:
		_persistence.inventory.append(item)
		inventory_updated.emit()

func has_item(item_name: String) -> bool:
	for item in _persistence.inventory:
		if item.name == item_name:
			return true
	return false

func get_inventory() -> Array:
	return _persistence.inventory


