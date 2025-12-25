extends Panel

@export var characters:Dictionary[String,MarginContainer];
@export var default_character:String=GameData.ELEANOR_KEY;
@onready var random = RandomNumberGenerator.new()

func _ready() -> void:
	set_character(default_character)


func set_character(character:String) -> void:
	GameData.active_character = character;
	for key in characters:
		characters[key].hide();
	
	characters[character].show();


func set_expression() -> void:
	#TODO : 
	pass


func shuffle_active_character() -> void:

	var shouldShuffle : bool = false;
	if GameData.current_energy <= 0:
		shouldShuffle = true;

	if shouldShuffle == false:
		var roll : int =random.randi_range(1,100)
		if roll<GameData.CHARACTER_SHUFFLE_CHANCE_ON_ENERGY_LEFT:
			shouldShuffle = true;

	if shouldShuffle == false:
		print("Skipping character shuffle")
		return;

	var active_character = GameData.active_character;
	var valid_character : Array[String] = [];
	for key in GameData.ALL_CHARACTERS:
		if key != active_character:
			valid_character.append(key);

	var radom_num = random.randf_range(0,valid_character.size()-1);
	var selected_character=valid_character[radom_num];
	set_character(selected_character);
	GameData.set_energy(GameData.MAX_ENERGY)

	print("Setting character to " + selected_character);
	print("Max energy replished to  " + str(GameData.MAX_ENERGY));
