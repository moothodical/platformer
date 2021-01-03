extends KinematicBody2D

onready var sprite = $Rig/Sprite
onready var rig = $Rig

const UP = Vector2(0, -1)
var velocity = Vector2(10, 0)
var gravity = 850
var is_grounded
var move_dir

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func check_is_grounded():
	return true if $GroundedRaycast.is_colliding() else false

# Moves back and forth between platform
func apply_movement():
	is_grounded = check_is_grounded()
	if !is_grounded:
		_update_velocity()
	velocity = move_and_slide(velocity, UP) 
	$GroundedLabel.text = str(is_grounded)

func apply_gravity(delta):
	velocity.y += gravity * delta

# changes direction of enemy when edge of platform
func _update_velocity():
	velocity.x = -velocity.x
	if velocity.x > 1:
		rig.scale.x = 1
	else:
		rig.scale.x = -1

