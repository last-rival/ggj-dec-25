extends PanelContainer

signal close_requested

@onready var name_label = $MarginContainer/VBoxContainer/NameLabel
@onready var desc_label = $MarginContainer/VBoxContainer/DescLabel
@onready var icon_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var placeholder_poly = $MarginContainer/VBoxContainer/InventoryContainer/Polygon2D
@onready var placeholder_container = $MarginContainer/VBoxContainer/InventoryContainer

@onready var use_button = $MarginContainer/VBoxContainer/UseButton

var current_item: InventoryItem

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
	
	use_button.visible = can_use

func _on_use_button_pressed():
	if current_item:
		print("Used item: ", current_item.name)
		if current_item.on_use_set_variable != "":
			GameData.set_variable(current_item.on_use_set_variable, current_item.on_use_set_value)
		
		close_requested.emit()

func _on_close_button_pressed():
	close_requested.emit()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not get_global_rect().has_point(event.global_position):
			close_requested.emit()
