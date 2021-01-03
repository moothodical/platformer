extends "res://Scripts/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("follow")
	add_state("attack")
	call_deferred("set_state", states.idle)
	pass 

func _state_logic(delta):
	parent.apply_gravity(delta)
	parent.apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			pass
		states.follow:
			pass
		states.attack:
			pass
	return null

# setting anim, tween, timers, etc
func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
