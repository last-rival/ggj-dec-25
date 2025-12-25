extends Node3D

@onready var _dialogue_drawer = $HUD/DialogueDrawer
@onready var _dialogue_list = $HUD/DialogueList
@onready var _character = $innterogation_room/innterogation_room/bg/character

@export var break_room : CanvasLayer;
@export var innterogation_room : CanvasLayer;
@export var hud : CanvasLayer;


var is_dialogue_running: bool = false


func _ready() -> void:
	_dialogue_drawer.hide()
	_dialogue_drawer.connect("break_room",on_break_room_trigger)
	_dialogue_drawer.connect("energy_used", on_energy_use_trigger)

	# Add clue items to inventory
	# Load specific character clues
	# Load specific character clues
	
	# 1. Chits (3 per character, except Priest)
	var chit_chars = ["eleanor", "rachel", "prudence", "briar"]
	for char_name in chit_chars:
		for i in range(1, 4):
			var path = "res://stuff/game_stuff/inventory/clues/characters/%s/chit_%d.tres" % [char_name, i]
			if ResourceLoader.exists(path):
				var item = load(path)
				if item: GameData.add_item(item)

	# 2. Dossiers (1 per character, including Priest)
	var dossier_chars = ["eleanor", "rachel", "prudence", "briar", "priest"]
	for char_name in dossier_chars:
		var path = "res://stuff/game_stuff/inventory/clues/characters/%s/dossier_1.tres" % [char_name]
		if ResourceLoader.exists(path):
			var item = load(path)
			if item: GameData.add_item(item)

	# Load Key Items
	var photo = load("res://stuff/game_stuff/inventory/clues/photo.tres")
	var cup = load("res://stuff/game_stuff/inventory/clues/cup.tres")
	var flower = load("res://stuff/game_stuff/inventory/clues/flower.tres")
	
	if photo: GameData.add_item(photo)
	if cup: GameData.add_item(cup)
	if flower: GameData.add_item(flower)
	
	# Connect Inventory Button
	$HUD/InventoryButton.pressed.connect(func(): $HUD/ExpandedInventoryUI.toggle())
	
	# Handle visibility
	GameData.inventory_visibility_changed.connect(func(v): $HUD/InventoryButton.visible = v)
	# Set initial state (default true if not set)
	var is_inv_visible = GameData.get_variable("inventory_button_visible")
	if is_inv_visible == null: is_inv_visible = true
	$HUD/InventoryButton.visible = is_inv_visible
	
	# Start Game
	load_innterogation_room()


# Load and unload scene
func load_innterogation_room() -> void:
	can_visit_break_room = false;
	innterogation_room.show();
	hud.show();
	break_room.hide();
	change_active_character()


func load_break_room() -> void:
	break_room.show();
	innterogation_room.hide();
	hud.hide();


func _input(event: InputEvent) -> void:
	if not is_dialogue_running:
		return

	if event.is_action_pressed("ui_accept"):
		_dialogue_drawer.next()
	elif event.is_action_pressed("ui_down"):
		_dialogue_drawer.next_option()
	elif event.is_action_pressed("ui_up"):
		_dialogue_drawer.previous_option()


func _on_dialogue_drawer_dialogue_ended() -> void:
	_dialogue_drawer.hide()
	_dialogue_list.show()
	is_dialogue_running = false
	if can_visit_break_room:
		load_break_room()


func _on_test_dialogue_button_pressed() -> void:
	_start_dialogue("test")


func _on_intro_dialogue_pressed() -> void:
	_start_dialogue("intro")


func _on_passive_dialogue_pressed() -> void:
	_start_dialogue("passive")


func _on_active_dialogue_pressed() -> void:
	_start_dialogue("active")


func _on_variables_dialogue_button_pressed() -> void:
	_start_dialogue("variables")


func _on_game_demo_pressed() -> void:
	_start_dialogue("game_demo")

func _start_dialogue(dialogue: String) -> void:
	_dialogue_list.hide()
	_dialogue_drawer.show()
	_dialogue_drawer.start(dialogue)
	is_dialogue_running = true

var can_visit_break_room:bool=false;
func on_break_room_trigger() -> void:
	can_visit_break_room=true;

func _on_dialogue_drawer_active_check_started() -> void:
	$HUD/ActiveCheckAnimation.show()


func _on_dialogue_drawer_active_check_ended() -> void:
	$HUD/ActiveCheckAnimation.hide()


func _on_restart_scene_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_exit_break_room_pressed() -> void:
	load_innterogation_room()


func change_active_character() -> void:
	var intro_completed = GameData.get_variable("intro_completed");
	var intro_value = false;

	if intro_completed != null:
		intro_value=intro_completed as bool

	if intro_value == false:
		return

	_character.shuffle_active_character();


func on_energy_use_trigger(amount:int) -> void:
	GameData.modify_energy(-amount)

# TODO : Updated the game to load different conversation files based on the active character.
# The way this will work is you carry on a conversation, the character runs of energy and then you enter break room
# Next character loads in looks at the interal and external variables and picks up from the required place.
# This that are difficult to do are -> Jumping from one place section of the script to another section via code.
# Should be possible need to check the documentation
