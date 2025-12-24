extends VBoxContainer

@export var active_color: Color = Color.CYAN
@export var inactive_color: Color = Color(0.2, 0.2, 0.2, 0.5)

@onready var indicators_container = $Indicators
@onready var debug_buttons = $DebugButtons
@onready var debug_info = $DebugInfo

func _ready():
	# Initial update
	update_display(GameData.current_energy)
	
	# Connect signal
	GameData.energy_updated.connect(update_display)
	GameData.energy_debug_visibility_changed.connect(_on_debug_visibility_changed)
	
	# Setup debug buttons
	$DebugButtons/ReduceButton.pressed.connect(func(): GameData.modify_energy(-1))
	# Reset now refills energy to Max (5), which effectively clears exhaustion
	$DebugButtons/ResetExhaustButton.pressed.connect(func(): GameData.set_energy(GameData.MAX_ENERGY))
	
	# Initial visibility
	var is_debug = GameData.get_variable("energy_debug_visible")
	if is_debug == null: is_debug = false
	_on_debug_visibility_changed(is_debug)

func _on_debug_visibility_changed(visible: bool):
	debug_buttons.visible = visible
	debug_info.visible = visible

func update_display(amount: int):
	# Update Indicators
	var indicators = indicators_container.get_children()
	for i in range(indicators.size()):
		var indicator = indicators[i]
		if indicator is ColorRect:
			if i < amount:
				indicator.color = active_color
			else:
				indicator.color = inactive_color

	# Update Debug Info
	if debug_info.visible:
		var ex = GameData.get_variable("exhausted")
		debug_info.text = "Energy: %d | Exhausted: %s" % [amount, str(ex)]
