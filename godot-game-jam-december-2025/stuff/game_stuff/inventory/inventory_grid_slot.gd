extends VBoxContainer

signal clicked(item: InventoryItem)

@onready var slot = $InventorySlot
@onready var label = $NameLabel

var item: InventoryItem

func _ready():
	slot.item_clicked.connect(_on_slot_clicked)

func set_item(new_item: InventoryItem):
	item = new_item
	slot.set_item(new_item)
	label.text = new_item.name

func _on_slot_clicked(clicked_item):
	clicked.emit(clicked_item)
