extends Button

signal item_clicked(item: InventoryItem)

var item: InventoryItem

@onready var icon_rect = $MarginContainer/TextureRect
@onready var slot_bg = $MarginContainer/Panel


func set_item(new_item: InventoryItem):
	item = new_item
	icon_rect.visible = false # Hide texture for now as we use poly

	if item.icon:
		icon_rect.texture = item.icon
		icon_rect.visible = true
	
	if has_node("NameLabel"):
		$NameLabel.text = item.name
		#$NameLabel.visible = true
	
	disabled = false

func show_bg_visible(visible:bool):
	slot_bg.visible = visible;

func clear():
	item = null
	icon_rect.texture = null
	icon_rect.visible = false
	if has_node("NameLabel"):
		$NameLabel.visible = false
	disabled = true

func set_used_state(is_used: bool):
	disabled = is_used
	if is_used:
		modulate = Color(0.5, 0.5, 0.5, 1)
	else:
		modulate = Color(1, 1, 1, 1)

func _on_pressed():
	if item:
		item_clicked.emit(item)
