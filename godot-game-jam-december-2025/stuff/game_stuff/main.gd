extends Node2D

@onready var _dialogue_drawer = $HUD/DialogueDrawer
@onready var _character : CharacterAlter = $innterogation_room/BG/Character

@onready var break_room = $break_room;
@onready var break_room_hud: CanvasLayer = $break_room/break_room;
@onready var innterogation_room : Node2D = $innterogation_room;
@onready var hud : CanvasLayer = $HUD
@onready var audio_manager : AudioManager = $audio_manager

var is_dialogue_running: bool = false
var can_visit_break_room:bool = false;

func _ready() -> void:
	_dialogue_drawer.hide()
	_dialogue_drawer.connect("break_room",on_break_room_trigger)
	_dialogue_drawer.connect("energy_used", on_energy_use_trigger)
	_dialogue_drawer.connect("set_switch", on_set_switch_trigger)
	_dialogue_drawer.connect("set_bgm",on_bgm_set)
	_dialogue_drawer.connect("set_sfx",on_sfx_set)
	_dialogue_drawer.connect("set_expr",on_expression_set)
	_dialogue_drawer.connect("set_expr_solo",on_expression_solo_set)

	break_room.connect("exit_break_room", on_break_room_exit_pressed)

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
	var secret =  load("res://stuff/game_stuff/inventory/clues/characters/briar/secret.tres")
	var song =  load("res://stuff/game_stuff/inventory/clues/song.tres")
	
	if photo: GameData.add_item(photo)
	if cup: GameData.add_item(cup)
	if flower: GameData.add_item(flower)
	if secret: GameData.add_item(secret)
	if song: GameData.add_item(song)

	# Start Game
	load_innterogation_room()


# Load and unload scene
func load_innterogation_room() -> void:
	can_visit_break_room = false;
	innterogation_room.show();
	hud.show();
	break_room.hide();
	break_room_hud.hide();
	break_room.close();
	change_active_character();


func load_break_room() -> void:
	break_room.set_up();
	break_room.show();
	break_room_hud.show();
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
	is_dialogue_running = false
	if can_visit_break_room:
		load_break_room()


func _on_game_demo_pressed() -> void:
	_start_dialogue()


func _start_dialogue() -> void:
	_dialogue_drawer.show()
	_dialogue_drawer.start_conversation()
	is_dialogue_running = true


func on_break_room_trigger() -> void:
	can_visit_break_room=true;


func _on_dialogue_drawer_active_check_started() -> void:
	$HUD/ActiveCheckAnimation.show()


func _on_dialogue_drawer_active_check_ended() -> void:
	$HUD/ActiveCheckAnimation.hide()


func _on_restart_scene_button_pressed() -> void:
	get_tree().reload_current_scene()


func on_break_room_exit_pressed() -> void:
	load_innterogation_room()

func change_active_character() -> void:
	var intro_completed = GameData.get_variable("intro_completed");
	var intro_value = false;

	if intro_completed != null:
		intro_value=intro_completed as bool

	if intro_value == false:
		if GameData.current_energy <= 0:
			print("Max energy replished to  " + str(GameData.MAX_ENERGY));
			GameData.set_energy(GameData.MAX_ENERGY)
		return

	_character.shuffle_active_character();


func on_energy_use_trigger(amount:int) -> void:
	GameData.modify_energy(-amount)

func on_set_switch_trigger(chances:Array) -> void:
	if chances == null || chances.size() != 5 :
		print("Switch chance parameters are empty or less than 5");
		return

	GameData.character_switch_chances[GameData.BRIAR_KEY] = int(chances[0]);
	GameData.character_switch_chances[GameData.CHELL_KEY] = int(chances[1]);
	GameData.character_switch_chances[GameData.ELEANOR_KEY] = int(chances[2]);
	GameData.character_switch_chances[GameData.PRUDENCE_KEY] = int(chances[3]);
	GameData.character_switch_chances[GameData.RACHEL_KEY] = int(chances[4]);
	
	for key in GameData.character_switch_chances:
		print("Set Switch Chance for "+str(key)+" = "+str(GameData.character_switch_chances[key]));


func on_bgm_set(keys:Array) -> void:
	if keys == null || keys.size() == 0:
		return

	var key = keys[0]
	audio_manager.play_bgm(key)


func on_sfx_set(keys:Array) -> void:
	if keys == null || keys.size() == 0:
		return

	var key = keys[0]
	audio_manager.play_sfx(key)

func on_expression_set(keys:Array):
	if keys == null || keys.size() != 2:
		return

	var char_id = keys[0]
	var exp_id = keys[1]
	_character.set_expression(char_id,exp_id)

func on_expression_solo_set(keys:Array):
	if keys == null || keys.size() != 2:
		return

	var char_id = keys[0]
	var exp_id = keys[1]
	_character.set_expression_solo(char_id,exp_id)

# TODO : Updated the game to load different conversation files based on the active character.
# The way this will work is you carry on a conversation, the character runs of energy and then you enter break room
# Next character loads in looks at the interal and external variables and picks up from the required place.
# This that are difficult to do are -> Jumping from one place section of the script to another section via code.
# Should be possible need to check the documentation
