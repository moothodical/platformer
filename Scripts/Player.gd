extends KinematicBody2D

const UP = Vector2(0, -1)
const MAX_JUMP_VEL = -350
const MIN_JUMP_VEL = 10
const MAX_SPEED = 500

var velocity = Vector2()
var acceleration = 50
var move_speed = 500
var gravity = 1200
var jump_velocity = -500
var jump_damp = 0.8
var is_grounded

func apply_movement():
	velocity = move_and_slide(velocity, UP) 
	is_grounded = check_is_grounded()

func apply_gravity(delta):
	velocity.y += gravity * delta

func _get_h_weight():
	return 0.25 if is_grounded else 0.025 # player has less control in the air

func _handle_move_input():
	var move_dir = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, MAX_SPEED * move_dir, _get_h_weight())
	
	# Flip horizontally if facing left, otherwise default face right
	if move_dir == -1: # if facing left
		print("entered if")
		get_node("CharacterRig/Torso").set_flip_h(true)
	else:
		get_node("CharacterRig/Torso").set_flip_h(false)

func check_is_grounded():
	for raycast in $DownRaycasts.get_children():
		if raycast.is_colliding():
			return true
	return false
			

