extends KinematicBody

var move: Vector3
var move_axis: Vector2

onready var camera: Camera = get_node("Camera")

export var gravity: int = 15
export var speed: int = 10
export var jump: int = 10
export var mouse_sensitivity: float = 0.5


func _input(event: InputEvent) -> void:
	move_axis.y = Input.get_action_strength("game_up") - Input.get_action_strength("game_down")
	move_axis.x = Input.get_action_strength("game_left") - Input.get_action_strength("game_right")
	move_axis = move_axis.normalized()
	
	if is_on_floor():
		move.y = Input.get_action_strength("game_jump") * jump
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(event.relative.x*-mouse_sensitivity))
		camera.rotate_x(deg2rad(event.relative.y*-mouse_sensitivity))
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	
func _physics_process(delta: float) -> void:
	var z = global_transform.basis.z
	var x = global_transform.basis.x
	
	move.z = -(z * move_axis.y + x * move_axis.x).z * speed
	move.x = -(z * move_axis.y + x * move_axis.x).x * speed
	
	move.y -= gravity*delta
	
	move = move_and_slide(move, Vector3.UP)
