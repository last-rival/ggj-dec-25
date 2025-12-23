extends Button

signal item_clicked(item: InventoryItem)

var item: InventoryItem

@onready var placeholder_poly = $MarginContainer/InventoryContainer/Polygon2D
@onready var icon_rect = $MarginContainer/TextureRect


func set_item(new_item: InventoryItem):
	item = new_item
	icon_rect.visible = false # Hide texture for now as we use poly
	
	if item.placeholder_color:
		placeholder_poly.color = item.placeholder_color
		placeholder_poly.visible = true
	else:
		placeholder_poly.visible = false

	if item.icon:
		icon_rect.texture = item.icon
		icon_rect.visible = true
		placeholder_poly.visible = false
	
	disabled = false

func clear():
	item = null
	icon_rect.texture = null
	icon_rect.visible = false
	placeholder_poly.visible = false
	disabled = true

func _on_pressed():
	if item:
		item_clicked.emit(item)
