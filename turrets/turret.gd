extends Area2D

## Turrets script. A turret is an Area2D object that detects when others Area2D object enter and leave it's range.
## What this means is that this area is the reach of the tower, not it's body.


@export var reach: float = 150.0 # Detection radius in pixels
@export var size: float = 40.0 # Size of the square thar represents the turret
@export var color: Color = Color("f28c28") # Color of the square
@export var damage: float = 20.0 # Damage of each shot
@export var fire_rate: float = 1.0 # shots per second

var robots_in_range: Array = []
var reload_time: float = 0.0
var flash: float = 0.0

## As soon as the turret appears, we execute this block.
## The first three lines create the circle of the turret.
## The last two are signals that trigger when robots enter or leave the turret's range
func _ready() -> void:
	var shape := CircleShape2D.new()
	shape.radius = reach
	$CollisionShape2D.shape = shape
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


## Each frame this block executes. delta is the time that has passed since the last execution.
## Gets the robot that has been the longest in range and shoots it.
## queue_redraw is called so the line pointing at the robot is shown and to show that the robot is advancing.
func _process(delta: float) -> void:
	reload_time -= delta
	flash -= delta
	var target := get_target()
	if target and reload_time <= 0:
		shoot(target)
	queue_redraw()

##Calls the receive_damage function of the robots, restarts reload time and shows flash for 0,1 seconds
func shoot(target) -> void:
	target.receive_damage(damage)
	reload_time = 1.0 / fire_rate
	flash = 0.1

## Adds the area2D object that entered the area to the list of robots.
## Only if said object belongs to the "robots" group.
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("robots"):
		robots_in_range.append(area)

# When the objects leave the turret's range, is removed from the list
func _on_area_exited(area: Area2D) -> void:
	robots_in_range.erase(area)

# Gets the first robot of the list. It's the one that's been the longest in range.
func get_target() -> Area2D:
	for robot in robots_in_range:
		if is_instance_valid(robot):
			return robot
	return null

## Three things are drawn:
## A circle showing the turret's range.
## The rectangle of the turret.
## The line that points to the target, and the flash that shows when the turret shoots
func _draw() -> void:
	draw_arc(Vector2.ZERO, reach, 0, 360, 64, Color(color, 0.3), 2.0)
	draw_rect(Rect2(-size / 2, -size / 2, size, size), color)
	var target := get_target()
	if target:
		var thickness := 5.0 if flash > 0 else 1.0
		var line_color := Color.WHITE if flash > 0 else color
		draw_line(Vector2.ZERO, to_local(target.global_position), line_color, thickness)
