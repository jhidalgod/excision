extends Area2D

@export var path: Path2D #The path that the robot will follow. Assigned in level_1.gd
@export var speed: float = 100.0 #Pixels per second.
@export var radius: float = 16.0 #Radius of the circle that represents the robot.
@export var color: Color = Color("3fa9f5")
@export var max_health: float = 100.0

var distance: float = 0.0 #How many pixels has the robot traveled since the start.
var health: float

# The robot is added to the "robots" group, so turrets can shoot them, but not other turrets.
func _ready() -> void:
	add_to_group("robots")
	health = max_health

## Each frame the robot avances. If the distance traversed is greater than the length of the path, the robot disappears.
## sample_baked(distance) gives us the point in the path that the robot has reached.
## to_global() converts that point to coordinates in the map. 
func _process(delta: float) -> void:
	if path == null:
		return
	distance += speed * delta
	var length := path.curve.get_baked_length()
	if distance >= length:
		reach_core()
		return
	global_position = path.to_global(path.curve.sample_baked(distance))

# Substract the damage received to the health of the robot
#redraw it's healthbar and remove the robot if the health is 0
func receive_damage(amount: float) -> void:
	health -= amount
	queue_redraw()
	if health <= 0:
		queue_free()


func reach_core() -> void:
	print("A robot has reached the core")
	queue_free()

#Draw the circle of the robot, and the healthbar
func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
	var y := -radius - 10
	var health_width : float = radius * 2 * maxf(health, 0) / max_health
	draw_rect(Rect2(-radius, y, radius * 2, 5), Color(0.15, 0.15, 0.15))
	draw_rect(Rect2(-radius, y, health_width, 5), Color("7ee081"))
