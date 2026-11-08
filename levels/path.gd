extends Path2D

## At level start, the path is not visible. In this script the points are read and painted on the scene.

@export var width: float = 40.0
@export var color: Color = Color(0.74, 0.82, 0.94)

func _ready() -> void:
	var line := Line2D.new()
	line.points = curve.get_baked_points()
	line.width = width
	line.default_color = color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	add_child(line)
