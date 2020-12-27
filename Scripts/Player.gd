extends KinematicBody2D

const UP = Vector2(0, -1)

var velocity = Vector2()
var move_speed = 500
var gravity = 1200
var jump_velocity = -500
var is_grounded

func apply_movement():
	velocity = move_and_slide(velocity, UP) 
	is_grounded = check_is_grounded()

func apply_gravity(delta):
	velocity.y += gravity * delta

func _get_h_weight():
	return 0.2 if is_grounded else 0.1 # player has less control in the air

func _handle_move_input():
	var move_dir = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_dir, _get_h_weight())

func check_is_grounded():
	for raycast in $DownRaycasts.get_children():
		if raycast.is_colliding():
			return true
	return false
			

