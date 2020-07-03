extends Area2D


const SPEED = 150
var velocity = Vector2()
var direction = 1

func set_projectile_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED*delta*direction
	translate(velocity)
	$AnimatedSprite.play("Shoot")
	 
	 


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_ProjectileUpgrade_body_entered(body):
	if "Enemy" in body.name:
		body.dead(2)
	queue_free()
