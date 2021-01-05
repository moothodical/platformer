extends Control

onready var health_bar = $HealthBar

func update_health(health):
	health_bar.value = health
	if health >= 70:
		pass
		health_bar.tint_progress = Color(0, 255, 0, 255)
	elif health >= 30 && health < 70:
		health_bar.tint_progress = Color(255, 255, 0, 255)
	else:
		health_bar.tint_progress = Color(255, 0, 0, 255)

func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
