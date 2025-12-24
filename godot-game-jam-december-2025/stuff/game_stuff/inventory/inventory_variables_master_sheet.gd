extends Node

# INVENTORY VARIABLES MASTER SHEET
# Use this file to copy-paste variable settings into GameData.gd -> _ready()
# or use it as a reference for your dialogue system.
# Change 'false' to 'true' to unlock items for testing.

func _ready():
	# ==========================================
	# DEFAULT UNLOCKED ITEMS (Start of Game)
	# ==========================================
	GameData.set_variable("found_body_photo", true)
	GameData.set_variable("found_poisoned_cup", true)
	GameData.set_variable("found_priest_dossier_1", true)

	# ==========================================
	# LOCKED ITEMS (Set to true to unlock)
	# ==========================================

	# --- KEY ITEMS ---
	GameData.set_variable("found_strange_flower", false)

	# --- ELEANOR ---
	GameData.set_variable("found_eleanor_dossier_1", false)
	GameData.set_variable("found_eleanor_chit_1", false)
	GameData.set_variable("found_eleanor_chit_2", false)
	GameData.set_variable("found_eleanor_chit_3", false)

	# --- RACHEL ---
	GameData.set_variable("found_rachel_dossier_1", false)
	GameData.set_variable("found_rachel_chit_1", false)
	GameData.set_variable("found_rachel_chit_2", false)
	GameData.set_variable("found_rachel_chit_3", false)

	# --- PRUDENCE ---
	GameData.set_variable("found_prudence_dossier_1", false)
	GameData.set_variable("found_prudence_chit_1", false)
	GameData.set_variable("found_prudence_chit_2", false)
	GameData.set_variable("found_prudence_chit_3", false)

	# --- BRIAR ---
	GameData.set_variable("found_briar_dossier_1", false)
	GameData.set_variable("found_briar_chit_1", false)
	GameData.set_variable("found_briar_chit_2", false)
	GameData.set_variable("found_briar_chit_3", false)

	# ==========================================
	# USE AVAILABLE VARIABLES (Controls 'USE' button state)
	# Set to TRUE to enable the Use button
	# ==========================================
    
	GameData.set_variable("photo_available", false)
	GameData.set_variable("cup_available", false)
	GameData.set_variable("flower_available", false)
	GameData.set_variable("priest_dossier_1_available", false)
	
	GameData.set_variable("eleanor_dossier1_available", false)
	GameData.set_variable("eleanor_chit1_available", false)
	GameData.set_variable("eleanor_chit2_available", false)
	GameData.set_variable("eleanor_chit3_available", false)
	
	GameData.set_variable("rachel_dossier1_available", false)
	GameData.set_variable("rachel_chit1_available", false)
	GameData.set_variable("rachel_chit2_available", false)
	GameData.set_variable("rachel_chit3_available", false)
	
	GameData.set_variable("prudence_dossier1_available", false)
	GameData.set_variable("prudence_chit1_available", false)
	GameData.set_variable("prudence_chit2_available", false)
	GameData.set_variable("prudence_chit3_available", false)
	
	GameData.set_variable("briar_dossier1_available", false)
	GameData.set_variable("briar_chit1_available", false)
	GameData.set_variable("briar_chit2_available", false)
	GameData.set_variable("briar_chit3_available", false)

	# ==========================================
	# ITEM USED AVAILABLE VARIABLES (Controls 'ITEM USED' button state)
	# Set to TRUE to enable the Used button
	# ==========================================

	GameData.set_variable("photo_used", false)
	GameData.set_variable("cup_used", false)
	GameData.set_variable("flower_used", false)
	GameData.set_variable("priest_dossier_1_used", false)
	
	GameData.set_variable("eleanor_dossier1_used", false)
	GameData.set_variable("eleanor_chit1_used", false)
	GameData.set_variable("eleanor_chit2_used", false)
	GameData.set_variable("eleanor_chit3_used", false)
	
	GameData.set_variable("rachel_dossier1_used", false)
	GameData.set_variable("rachel_chit1_used", false)
	GameData.set_variable("rachel_chit2_used", false)
	GameData.set_variable("rachel_chit3_used", false)
	
	GameData.set_variable("prudence_dossier1_used", false)
	GameData.set_variable("prudence_chit1_used", false)
	GameData.set_variable("prudence_chit2_used", false)
	GameData.set_variable("prudence_chit3_used", false)
	
	GameData.set_variable("briar_dossier1_used", false)
	GameData.set_variable("briar_chit1_used", false)
	GameData.set_variable("briar_chit2_used", false)
	GameData.set_variable("briar_chit3_used", false)
