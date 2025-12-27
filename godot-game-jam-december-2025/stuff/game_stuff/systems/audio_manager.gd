extends Node
class_name AudioManager

@onready var bgms : Dictionary[String,AudioStreamWAV] = {
	"bgm_base" : preload("res://stuff/audio/AlterGirl_Base_Loop.wav"),
	"bgm_child" : preload("res://stuff/audio/AlterGirl_Child_Loop.wav"),
	"bgm_core" : preload("res://stuff/audio/AlterGirl_Core_Loop.wav"),
	"bgm_logic" : preload("res://stuff/audio/AlterGirl_Logical_Loop.wav"),
	"bgm_resent" : preload("res://stuff/audio/AlterGirl_Resentful_Loop.wav"),
	"sfx_eng_drop" : preload("res://stuff/audio/SFX_EnergyEmpty.wav"),
	"sfx_eng_fill" : preload("res://stuff/audio/SFX_EnergyFill.wav"),
	"sfx_notif" : preload("res://stuff/audio/SFX_Notification.wav"),
	"sfx_sus" : preload("res://stuff/audio/SFX_Sus.wav"),
	"sfx_eng_tired" : preload("res://stuff/audio/SFX_Tired.wav"),
}

@onready var bgm_player_1 : AudioStreamPlayer = $bgm_1
@onready var bgm_player_2 : AudioStreamPlayer = $bgm_2

@onready var sfx_players : Array[AudioStreamPlayer] = [	$sfx_1, $sfx_2, $sfx_3, $sfx_4]

var active_bgm_player : AudioStreamPlayer
var old_bgm_player : AudioStreamPlayer
var do_fade = false
var fade_duration = 2.0
var fade_timer = 0.0
var sfx_counter : int = 0

func _ready() -> void:
	play_bgm("bgm_base")
	
	GameData.energy_changed.connect(on_energy_changed)

func play_bgm(bgm : String):
	var audio_stream : AudioStreamWAV = bgms[bgm]
	if audio_stream == null:
		return

	if active_bgm_player == null:
		active_bgm_player = bgm_player_1
		
		active_bgm_player.stream = audio_stream
		active_bgm_player.play()
		do_fade = true
		fade_timer = 0
		return

	old_bgm_player = active_bgm_player
	if active_bgm_player == bgm_player_1:
		active_bgm_player = bgm_player_2
	
	if active_bgm_player == bgm_player_2:
		active_bgm_player = bgm_player_1

	active_bgm_player.stream = audio_stream
	active_bgm_player.play()
	do_fade = true
	fade_timer = 0

func _process(delta: float) -> void:
	if do_fade == false:
		return
	
	if fade_timer >= fade_duration:
		if old_bgm_player:
			old_bgm_player.stop()
		active_bgm_player.volume_linear = 1
		do_fade = false
		return

	fade_timer += delta
	var amount = fade_timer/fade_duration
	var neg_amount = 1-amount;
	
	if old_bgm_player:
		old_bgm_player.volume_linear = neg_amount

	if active_bgm_player:
		active_bgm_player.volume_linear = amount

func play_sfx(sfx_key : String):
	var audio_stream : AudioStreamWAV = bgms[sfx_key]
	if audio_stream == null:
		return

	var player = get_sfx_player()
	player.stream = audio_stream
	player.play()

func get_sfx_player() -> AudioStreamPlayer:
	var index = sfx_counter;
	sfx_counter += 1
	sfx_counter %= 4
	return sfx_players[index];


func on_energy_changed(value : bool):
	if value:
		play_sfx("sfx_eng_fill")
