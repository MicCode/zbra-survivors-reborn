extends CharacterBody2D

@export var player_reference: CharacterBody2D
var direction: Vector2
var speed: float = 75
var damage: float
var knockback: Vector2
var elite: bool = false:
	set(value):
		elite = value
		if value:
			%AnimatedSprite2D.material = load("res://shaders/rainbow.tres")
			scale = Vector2(1.5, 1.5)

var type: EnemyType:
	set(value):
		type = value
		%AnimatedSprite2D.sprite_frames = value.frames
		damage = value.damage
	

func _physics_process(delta: float) -> void:
	var separation = (player_reference.position - position).length()
	if separation >= 500 and not elite:
		queue_free()
	
	if player_reference.position.x - position.x > 0:
		%AnimatedSprite2D.flip_h = true
	else:
		%AnimatedSprite2D.flip_h = false
		
	velocity = (player_reference.position - position).normalized() * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50
