extends Resource
class_name InventoryItem

@export var name: String = "Item"
@export_multiline var description: String = "Description"
@export var icon: Texture2D
@export var placeholder_color: Color = Color.GRAY


@export_group("Usage Condition")
# If empty, always visible
@export var use_condition_variable: String = "" 
@export var use_condition_expected_value: bool = true

@export_group("Usage Effect")
@export var on_use_set_variable: String = ""
@export var on_use_set_value: bool = true
@export var on_use_dialogue: String = ""
