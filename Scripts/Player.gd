extends KinematicBody2D

onready var left_wall_raycasts = $WallRaycasts/LeftWallRaycasts
onready var right_wall_raycasts = $WallRaycasts/RightWallRaycasts

const UP = Vector2(0, -1)
const MAX_JUMP_VEL = -250
const MIN_JUMP_VEL = -100
const MAX_SPEED = 300
const WALL_JUMP_VEL = Vector2(MAX_SPEED, -300)

var velocity = Vector2()
var move_speed = 100
var gravity = 850
var is_grounded
var wall_direction = 1
var move_dir

func apply_movement():
	velocity = move_and_slide(velocity, UP) 
	is_grounded = check_is_grounded()
	$GroundedLabel.text = str(is_grounded)

func apply_gravity(delta):
	velocity.y += gravity * delta

func wall_jump():
	var wall_jump_velocity = WALL_JUMP_VEL
	wall_jump_velocity.x *= -wall_direction
	velocity = wall_jump_velocity

func _get_h_weight():
	return 0.2 if is_grounded else 0.1 # player has less control in the air

func _update_move_direction():
	move_dir = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))

func _handle_move_input():
	velocity.x = lerp(velocity.x, MAX_SPEED * move_dir, _get_h_weight())
	
	# Flip horizontally if facing left, otherwise default face right
	if move_dir == -1: # if facing left
		get_node("CharacterRig/Torso").set_flip_h(true)
	elif move_dir == 1: # facing right
		get_node("CharacterRig/Torso").set_flip_h(false)

func check_is_grounded():
	return true if $GroundedRaycast.is_colliding() else false

func _update_wall_direction():
	var is_near_wall_left = check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = check_is_valid_wall(right_wall_raycasts)
	
	if is_near_wall_left && is_near_wall_right:
		wall_direction = move_dir
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
	
func check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			#var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			#if dot > PI * 0.35 && dot < PI * 0.55:
			return true
	return false
	





