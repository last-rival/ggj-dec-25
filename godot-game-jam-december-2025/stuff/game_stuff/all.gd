extends Button


func _on_pressed() -> void:
	GameData.set_variable("found_body_photo",true)
	GameData.set_variable("found_poisoned_cup",true)
	GameData.set_variable("found_strange_flower",true)
	GameData.set_variable("found_lullaby",true)
	GameData.set_variable("found_priest_dossier_1",true)
	GameData.set_variable("found_eleanor_dossier_1",true)
	GameData.set_variable("found_eleanor_chit_1",true)
	GameData.set_variable("found_eleanor_chit_2",true)
	GameData.set_variable("found_eleanor_chit_3",true)
	GameData.set_variable("found_chell_dossier_1",true)
	GameData.set_variable("found_chell_chit_1",true)
	GameData.set_variable("found_chell_chit_2",true)
	GameData.set_variable("found_chell_chit_3",true)
	GameData.set_variable("found_prudence_dossier_1",true)
	GameData.set_variable("found_prudence_chit_1",true)
	GameData.set_variable("found_prudence_chit_2",true)
	GameData.set_variable("found_prudence_chit_3",true)
	GameData.set_variable("found_briar_dossier_1",true)
	GameData.set_variable("found_briar_chit_1",true)
	GameData.set_variable("found_briar_chit_2",true)
	GameData.set_variable("found_briar_chit_3",true)
	GameData.set_variable("found_briar_secret",true)
	GameData.character_switch_chances={
		GameData.BRIAR_KEY:1,
		GameData.CHELL_KEY:1,
		GameData.ELEANOR_KEY:1,
		GameData.PRUDENCE_KEY:1,
		GameData.RACHEL_KEY:1
	}
