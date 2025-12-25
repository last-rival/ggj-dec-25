extends Node

func _ready():
	# ==========================================
	# ENERGY VARIABLES
	# ==========================================
	GameData.set_variable("energy", 5) # Set to 0 to test exhaustion

	# ==========================================
	# REDUCE ENERGY FUNCTION:
	#GameData.modify_energy(-1)
	# ==========================================

	# ==========================================
	# RESET ENERGY FUNCTION:
	#GameData.set_energy(GameData.MAX_ENERGY)
	# ==========================================

	# ==========================================
	# DEFAULT EXHAUSTION
	GameData.set_variable("exhausted", false)
	
	# ==========================================
	# DEBUG CONTROLS
	GameData.set_variable("energy_debug_visible", true)
