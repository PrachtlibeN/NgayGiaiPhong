extends CharacterBody3D

@onready var state_machine = $AnimationTree["parameters/playback"]
@onready var camera = $Camera3D

var speed = 5.0
var jump_speed = 4.5
var mouse_sensitivity = 0.008
var is_run = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		state_machine.travel("Jump_Idle")
	
	get_input()
	move_and_slide()

func get_input() -> void:
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var movement_dir = transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	movement_dir = movement_dir.normalized()

	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	if input_dir != Vector2.ZERO:
		is_run = true
		state_machine.travel("Run")
	elif is_on_floor():
		is_run = false
		state_machine.travel("Idle")
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -PI / 2, PI / 2)
		


	if event.is_action_pressed("ui_accept") and is_on_floor():
		state_machine.travel("Jump_Idle")
		velocity.y = jump_speed
