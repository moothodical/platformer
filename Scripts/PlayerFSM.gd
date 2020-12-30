extends "res://Scripts/StateMachine.gd"
onready var anim = get_parent().get_node("CharacterRig/AnimationPlayer")

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("wall_slide")
	call_deferred("set_state", states.idle)

func _input(event):
	if event.is_action_pressed("jump") && parent.is_grounded:
		parent.velocity.y = parent.MAX_JUMP_VEL
	elif state == states.wall_slide:
		if event.is_action_pressed("jump"):
			parent.wall_jump()
			set_state(states.jump)
	elif state == states.jump:
		if event.is_action_released("jump") && parent.velocity.y < parent.MIN_JUMP_VEL: ## if jumping
			parent.velocity.y = parent.MIN_JUMP_VEL
	

func _state_logic(delta):
	parent._update_move_direction()
	parent._update_wall_direction()
	if state != states.wall_slide:
		parent._handle_move_input()
	parent.apply_gravity(delta)
	parent.apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if !parent.check_is_grounded():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif abs(parent.velocity.x) > parent.MAX_SPEED / 4:
				return states.run
		states.run:
			if !parent.check_is_grounded():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif abs(parent.velocity.x) < parent.MAX_SPEED / 4:
				return states.idle
		states.jump:
			print(parent.wall_direction)
			if parent.wall_direction != 0:
				return states.wall_slide
			elif parent.is_grounded:
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.wall_direction != 0:
				return states.wall_slide
			elif parent.is_grounded:
				return states.idle
			elif parent.velocity.y <  0:
				return states.jump
		states.wall_slide:
			if parent.wall_direction == 0:
				return states.fall
			
			
	
	return null

# setting anim, tween, timers, etc
func _enter_state(new_state, old_state):
	get_parent().get_node("StateLabel").text = states.keys()[state]
	if new_state == states.run:
		anim.play("run")
	elif new_state == states.idle:
		anim.play("idle")
	elif new_state == states.jump:
		anim.play("jump")
	elif new_state == states.fall:
		anim.play("fall")
	elif new_state == states.wall_slide:
		pass
		# play wall slide anim
		#parent.set_flip_h(true)
	
func _exit_state(old_state, new_state):
	if new_state != states.run:
		anim.stop(true)
	elif new_state != states.idle:
		anim.stop(true)
