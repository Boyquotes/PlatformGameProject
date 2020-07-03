extends KinematicBody2D


const GRAVITY = 10
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var direction = 1
var is_dead = false

export(int) var speed = 30
export(int) var hitpoint = 1
export(Vector2) var size = Vector2(1,1)


func _ready():
	scale = size
	pass 
	
#TODO: Function name misleading needs to be renamed to something else
func dead(damage):
	hitpoint -= damage
	
	#Death is only triggered when hitpoint is less or eq to 0
	if hitpoint <= 0:
		is_dead = true
		velocity = Vector2(0,0)
		$AnimatedSprite.play("Dead")
		$CollisionShape2D.set_deferred("disabled", true)
		$Timer.start()
		
		#Shaking when big enemy dies
		if scale > Vector2(1,1):
			get_parent().get_node("ScreenShake").screen_shake(1,10,100)

func _physics_process(delta):
	
	if is_dead == false:	
		velocity.x = speed*direction
		
		$AnimatedSprite.play("Move")
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
			
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)

#For ledges we use RayCast2D so it checks if the arrow is not colliding with any surface and otherwise is on wall function
	if is_on_wall() || $RayCast2D.is_colliding() == false:
		direction *= -1
		$RayCast2D.position.x *= -1
		
#Code for killing player when enemy touches player		
	if get_slide_count() > 0:
			for body in range(get_slide_count()):
				if "Player" in get_slide_collision(body).collider.name:
					get_slide_collision(body).collider.dead()
	
	



func _on_Timer_timeout():
	queue_free() #enemy should queue free itself after 2 seconds after it is dead
