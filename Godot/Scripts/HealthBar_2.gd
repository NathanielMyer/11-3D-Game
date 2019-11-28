extends Control

onready var health_bar = $HealthBar2

func _on_Player2_health_updated(health):
	health_bar.value = health
	
func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
