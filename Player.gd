extends KinematicBody2D

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1) #top of tiles 
const PROJECTILE = preload("res://Projectile.tscn")
const PROJECTILEUPGRADE = preload("res://ProjectileUpgrade.tscn")

var on_ground = false
var velocity = Vector2()
var is_dead = false
var projectile_power = 1


func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("Dead")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()

#This loops through at each frame 
func _physics_process(delta):	
	if is_dead == false:
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
			$AnimatedSprite.play("Run")
			#fun that you can access ui for your need in your code
			$AnimatedSprite.flip_h = false
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x*=-1
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
			$AnimatedSprite.play("Run")
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x*=-1
		else:
			velocity.x = 0
			if on_ground == true:
				$AnimatedSprite.play("Idle")
		
		if Input.is_action_pressed("ui_up"):
			if on_ground == true:
				velocity.y = JUMP_POWER
				on_ground = false
		
		if Input.is_action_just_pressed("ui_focus_next"): #space or tab
			var projectile = null
			
			#dealing with the projectile types
			if projectile_power == 1:
				projectile = PROJECTILE.instance()
			elif projectile_power == 2:
				projectile = PROJECTILEUPGRADE.instance()
				
			
			
			#Positioning of projectile
			if sign($Position2D.position.x) == 1:
				projectile.set_projectile_direction(1)
			else:
				projectile.set_projectile_direction(-1)
			get_parent().add_child(projectile)
			projectile.position = $Position2D.global_position
			
		velocity.y += GRAVITY
		
		if is_on_floor():
			on_ground = true
		else:
			on_ground = false
			if velocity.y < 0:
				$AnimatedSprite.play("Jump")
			else:
				$AnimatedSprite.play("Fall")
				
		
		velocity = move_and_slide(velocity, FLOOR)
		
		#Collision with enemy call dead function
		if get_slide_count() > 0:
			for body in range(get_slide_count()):
				if "Enemy" in get_slide_collision(body).collider.name:
					dead()


func _on_Timer_timeout():
	get_tree().change_scene("TitleScreen.tscn")
	
	
func player_Power_Up():
	projectile_power = 2
	
