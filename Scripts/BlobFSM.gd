extends "res://Scripts/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("attack")
	call_deferred("set_state", states.idle)
	pass 

func _state_logic(delta):
	parent.apply_movement()
	parent.apply_gravity(delta)

func _get_transition(delta):
	match state:
		states.idle:
			pass
			#if parent.check_sees_player():
				#return states.attack
		states.attack:
			parent._attack_player()
			if !parent.check_sees_player():
				return states.idle
			pass
	return null

# setting anim, tween, timers, etc
func _enter_state(new_state, old_state):
	get_parent().get_node("StateLabel").text = states.keys()[state]
	pass

func _exit_state(old_state, new_state):
	pass
