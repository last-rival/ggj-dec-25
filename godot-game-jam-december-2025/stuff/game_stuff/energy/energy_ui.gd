extends VBoxContainer

@onready var indicators_container = $Indicators
@onready var debug_buttons = $DebugButtons
@onready var debug_info = $DebugInfo

func _ready():
	# Initial update
	update_display(GameData.current_energy)
	
	# Connect signal
	GameData.energy_updated.connect(update_display)

	# Setup debug buttons
	$DebugButtons/ReduceButton.pressed.connect(func(): GameData.modify_energy(-1))
	# Reset now refills energy to Max (5), which effectively clears exhaustion
	$DebugButtons/ResetExhaustButton.pressed.connect(func(): GameData.set_energy(GameData.MAX_ENERGY))


func update_display(amount: int):
	# Update Indicators
	var indicators = indicators_container.get_children()
	for i in range(indicators.size()):
		var indicator = indicators[i]
		if indicator:
			if i < amount:
				indicator.get_child(0).show()
				indicator.get_child(1).hide()
			else:
				indicator.get_child(0).hide()
				indicator.get_child(1).show()

	# Update Debug Info
	if debug_info.visible:
		var ex = GameData.get_variable("exhausted")
		debug_info.text = "Energy: %d | Exhausted: %s" % [amount, str(ex)]
