extends "res://Scripts/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)

func _input(event):
	if event.is_action_pressed("jump") && parent.is_grounded:
		parent.velocity.y = parent.jump_velocity

func _state_logic(delta):
	parent._handle_move_input()
	parent.apply_gravity(delta)
	parent.apply_movement()

func _get_transition(delta):
	print("Grounded?: ", parent.is_grounded)
	print("X velo: ", parent.velocity.x)
	match state:
		states.idle:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_grounded:
				return states.idle	
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_grounded:
				return states.idle
			elif parent.velocity.y <  0:
				return states.jump
	
	return null

# setting anim, tween, timers, etc
func _enter_state(new_state, old_state):
	get_parent().get_node("StateLabel").text = states.keys()[state]

func _exit_state(old_state, new_state):
	pass
