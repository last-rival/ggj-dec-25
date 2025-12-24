extends PanelContainer

signal close_requested

@onready var name_label = $MarginContainer/VBoxContainer/NameLabel
@onready var desc_label = $MarginContainer/VBoxContainer/DescLabel
@onready var icon_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var placeholder_poly = $MarginContainer/VBoxContainer/InventoryContainer/Polygon2D
@onready var placeholder_container = $MarginContainer/VBoxContainer/InventoryContainer

@onready var use_button = $MarginContainer/VBoxContainer/UseButton
@onready var carry_button = $MarginContainer/VBoxContainer/CarryButton

var current_item: InventoryItem
var allow_use: bool = true

func setup(item: InventoryItem):
	current_item = item

func _ready():
	if current_item:
		update_info()

func update_info():
	name_label.text = current_item.name
	desc_label.text = current_item.description
	
	icon_rect.visible = false
	placeholder_container.visible = false
	
	if current_item.placeholder_color:
		placeholder_poly.color = current_item.placeholder_color
		placeholder_container.visible = true
	
	if current_item.icon:
		icon_rect.texture = current_item.icon
		icon_rect.visible = true
		placeholder_container.visible = false

	
	var can_use = true
	if current_item.use_condition_variable != "":
		var val = GameData.get_variable(current_item.use_condition_variable)
		if val == null:
			val = false
		
		if val != current_item.use_condition_expected_value:
			can_use = false
	
	if allow_use:
		use_button.visible = true
		use_button.disabled = not can_use
		carry_button.visible = false
	else:
		use_button.visible = false
		carry_button.visible = true
		
		# Optional: disable carry if already equipped?
		if GameData.has_item_equipped(current_item.name):
			carry_button.disabled = true
			carry_button.text = "CARRIED"
		else:
			carry_button.disabled = false
			carry_button.text = "CARRY"

func _on_use_button_pressed():
	if current_item:
		print("Used item: ", current_item.name)
		if current_item.on_use_set_variable != "":
			GameData.set_variable(current_item.on_use_set_variable, current_item.on_use_set_value)
		
		# Remove from active inventory after use
		GameData.remove_item_from_active(current_item)
		
		close_requested.emit()

func _on_carry_button_pressed():
	if current_item:
		var success = GameData.equip_item(current_item)
		if success:
			close_requested.emit()


func _on_close_button_pressed():
	close_requested.emit()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not get_global_rect().has_point(event.global_position):
			close_requested.emit()
