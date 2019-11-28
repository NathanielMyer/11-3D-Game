extends KinematicBody

signal health_updated(health)
signal killed()

var gravity = Vector3.DOWN * 12

var speed = 4
var jump_speed = 6.5
var jump = false

export (float) var max_health = 120

onready var health = max_health setget _set_health

var velocity = Vector3()

func _physics_process(delta):
	velocity += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector3.UP)
	if jump and is_on_floor():
		velocity.y = jump_speed
	if is_on_floor():
		gravity = Vector3.DOWN * 12
	
func get_input():
	var vy = velocity.y
	velocity = Vector3()
	if Input.is_action_pressed("strafe_right_2"):
		velocity += -transform.basis.x * speed
	if Input.is_action_pressed("strafe_left_2"):
		velocity += transform.basis.x * speed
	if Input.is_action_pressed("float_2"):
		gravity += transform.basis.y/4
	if Input.is_action_pressed("drop_2"):
		gravity += -transform.basis.y
		
	velocity.y = vy
	jump = false
	if Input.is_action_pressed("jump_2"):
		jump = true
		
func damage(amount):
	_set_health(health - amount)
		
func kill():
	get_tree().reload_current_scene()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")

func _on_SpikeArea2_body_entered(body):
	if body.has_method("damage"):
		body.damage(20)
