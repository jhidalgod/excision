extends Node2D

const ROBOT_SCENE := preload("res://units/robot.tscn")
const ROBOT_COST := 2

@export var energy: int = 10

#Save the nodes that the level with use.
@onready var path: Path2D = $Paths/Path1
@onready var units: Node2D = $Units
@onready var robot_button: Button = $HUD/UnitsBar/RobotButton
@onready var energy_text: Label = $HUD/UnitsBar/EnergyLabel
@onready var menu_button: Button = $HUD/UnitsBar/MenuButton

#Connects the buttons to the signals
func _ready() -> void:
	robot_button.pressed.connect(enviar_robot)
	update_hud()
	menu_button.pressed.connect(return_to_main_menu)

#If there's energy available, use it and send a new robot. 
func enviar_robot() -> void:
	if energy < ROBOT_COST:
		return
	energy -= ROBOT_COST
	var robot := ROBOT_SCENE.instantiate()
	robot.path = path
	units.add_child(robot)
	update_hud()

#Updates the HUD to show the correct energy value.
func update_hud() -> void:
	energy_text.text = "Energy: %d" % energy
	robot_button.disabled = energy < ROBOT_COST


func return_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
