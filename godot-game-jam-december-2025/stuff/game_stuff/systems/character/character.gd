extends Panel
class_name CharacterAlter

@onready var characters:Dictionary[String,Node2D] = {
	GameData.BRIAR_KEY:$Briar,
	GameData.CHELL_KEY:$Chell,
	GameData.ELEANOR_KEY:$Eleanor,
	GameData.PRUDENCE_KEY:$Prudence,
	GameData.RACHEL_KEY:$Rachel,
}

@export var default_character:String=GameData.ELEANOR_KEY;
@onready var random = RandomNumberGenerator.new()

func _ready() -> void:
	set_character(default_character, true)

func set_character(character:String,rest_pose : bool) -> void:
	GameData.active_character = character;
	for key in characters:
		characters[key].hide();
	
	var char_node = characters[character]
	char_node.show()
	
	if rest_pose == false:
		return

	var childCount = char_node.get_child_count()
	for i in range(childCount):
		char_node.get_child(i).hide()

	char_node.get_child(0).show()
	return


func set_expression(char_id: String, exp_id : String) -> void:
	var char_node = characters[char_id]
	if char_node == null:
		return

	var exp_node = char_node.get_node(exp_id)
	if exp_node == null:
		return

	var childCount = char_node.get_child_count()
	for i in range(childCount):
		char_node.get_child(i).hide()

	exp_node.show()


func shuffle_active_character() -> void:
	var start_energy = GameData.current_energy
	if GameData.current_energy <= 0:
		print("Max energy replished to  " + str(GameData.MAX_ENERGY));
		GameData.set_energy(GameData.MAX_ENERGY)

	var shouldShuffle : bool = false;
	if GameData.current_energy <= 0:
		shouldShuffle = true;

	var roll : int =random.randi_range(1,100)
	if shouldShuffle == false:
		if roll<GameData.CHARACTER_SHUFFLE_CHANCE_ON_ENERGY_LEFT:
			shouldShuffle = true;

	if shouldShuffle == false:
		print("Skipping character shuffle")
		return;

	var active_character = GameData.active_character;

	var switch_chances : Dictionary[String,int] = {};
	var total_sum = 0;
	for key : String in GameData.character_switch_chances:
		if key != active_character:
			var value : int = GameData.character_switch_chances[key];
			
			if value <= 0:
				continue;
			
			total_sum += value;
			switch_chances.set(key, value);

	if total_sum <= 0:
		total_sum = 1;

	roll = random.randi_range(1,total_sum);

	var selected_character = active_character;
	for key in switch_chances:
		var switch_value=switch_chances[key];
		roll -= switch_value;
		if roll <= 0:
			selected_character=key;
			break;

	if selected_character == active_character:
		if start_energy < GameData.current_energy:
			set_character(selected_character, true)

		print("Skipping character selection due to missed roll, set character is " + selected_character);
		return;

	set_character(selected_character, true);
	GameData.set_energy(GameData.MAX_ENERGY)

	print("Setting character to " + selected_character);
