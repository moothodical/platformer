extends KinematicBody2D

const UP = Vector2(0, -1)
const MAX_JUMP_VEL = -350
const MIN_JUMP_VEL = -100
const MAX_SPEED = 100

var velocity = Vector2()
var move_speed = 100
var gravity = 1000
var is_grounded

func apply_movement():
	velocity = move_and_slide(velocity, UP) 
	is_grounded = check_is_grounded()
	$GroundedLabel.text = str(is_grounded)

func apply_gravity(delta):
	velocity.y += gravity * delta

func _get_h_weight():
	return 0.2 if is_grounded else 0.1 # player has less control in the air

func _handle_move_input():
	var move_dir = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, MAX_SPEED * move_dir, _get_h_weight())
	
	# Flip horizontally if facing left, otherwise default face right
	if move_dir == -1: # if facing left
		print("entered if")
		get_node("CharacterRig/Torso").set_flip_h(true)
	elif move_dir == 1: # facing right
		get_node("CharacterRig/Torso").set_flip_h(false)

func check_is_grounded():
	return true if $GroundedRaycast.is_colliding() else false

