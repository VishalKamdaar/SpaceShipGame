extends CharacterBody3D


const MAXSPEED = 30
const MAXROTATEZ = 25
const MAXROTATEX = 25

# Not so aptly named. Change them later.
var speed = 5
var rAccelZ = 5
var rAccelX = 5

@onready var ship = $SHIP
@onready var animationPlayer = $AnimationPlayer

# Feels like a very shit way to implement rotation but it works prefectly well.
# Revisit Vectors, Matrices, Quaternions.
# Read through the Fundamentals of Computer Graphics.

# Also another issue is the fucking constants or the functions that switch radians to degrees and vice versa.
# They just don't wan't to be whole numbers. 
func _physics_process(delta):
	# Gets direction from keyboard input. Check Input.get_vector for more information
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Checks if there is any key pressed
	if input_dir:
		# Slowly increases acceleration for translation
		if speed < MAXSPEED:
			speed+=.5
		
		# Rotation(Rolling) and translation on the z axis (horizontal).
		if input_dir.x != 0:
			# Code does weird shit if I don't assign x_dir like this
			var x_dir = -1 if (input_dir.x > 0) else 1
			
			# Performs and limits rotation in both directions. Could make it a function if needed.
			if abs(rad_to_deg(self.rotation.z) + rAccelZ * x_dir) < abs(MAXROTATEZ):
				self.rotation.z += deg_to_rad(rAccelZ * x_dir)
			else:
				self.rotation.z = deg_to_rad(MAXROTATEZ * x_dir)
			
			# Translates ship horizontally with given speed
			var velo = (speed) * delta * -x_dir
			self.global_translate(Vector3(velo, 0, 0))
		
		else:
			# Rolls back to 0 in the same speed
			rotate_z_to_0()
			
			# Use this if it eventually works
			# rotate_to_0(self.rotation.z, rAccelZ)

		# Rotation(Pitching) and translation on the x axis (vertically).
		if input_dir.y != 0:
			# Assigning normally works for some reason but not for x_dir.
			var y_dir = 1 if (input_dir.y > 0) else -1
			
			# Performs and limits rotation in both directions
			if abs(rad_to_deg(self.rotation.x) + rAccelX * y_dir) < abs(MAXROTATEX):
				self.rotation.x += deg_to_rad(rAccelX * y_dir)
			else:
				self.rotation.x = deg_to_rad(MAXROTATEX * y_dir)
			
			# Translates ship vertically with given speed
			var velo = (speed) * delta * y_dir
			self.global_translate(Vector3(0, velo, 0))
		
		else:
			# Rolls back to 0 in the same speed
			rotate_x_to_0()
			
			# Use this if it eventually works
			# rotate_to_0(self.rotation.z, rAccelZ)

	else:
		# Slows ship momentum down slowly
		if(speed > 0):
			speed-=.5
		
		# Rotate to 0 incase they haven't
		rotate_z_to_0()
		rotate_x_to_0()
		
		# Would be nice if this worked.
		# I think it only passes the property value not the property itself
		# rotate_to_0(self.rotation.z, rAccelZ)
		# rotate_to_0(self.rotation.x, rAccelX)
	
	# Done only to get collision.
	# This was also the built in code that would apply the velocity changes and collision calculations
	move_and_slide()
	
	# Restarts level if collided with obstacle
	var col = get_last_slide_collision()
	if col:
		if col.get_collider().get_name().contains("Obstacle"):
			print("You dead: ", col.get_collider().get_name())
			get_tree().reload_current_scene()
		
	pass


# Either 2 functions below don't want to give an integer 
# or there is something wrong with the constants
func deg_to_rad(deg: float) -> int:
	return round((deg * PI) / 180)

func rad_to_deg(rad: float) -> int:
	return round((rad * PI) / 180)


# Rotate to 0 functions
func rotate_z_to_0():
	# Checks which direction
	if self.rotation.z < 0:
		# Rotates to 0 at the speed defined above
		self.rotation.z += deg_to_rad(rAccelZ)
		# Sets to 0 if it's gone above.
		if self.rotation.z > 0:
			self.rotation.z = 0
	
	elif self.rotation.z > 0:
		# Rotates to 0 at the speed defined above
		self.rotation.z -= deg_to_rad(rAccelZ)
		# Sets to 0 if it's gone below.
		if self.rotation.z < 0:
			self.rotation.z = 0
	
func rotate_x_to_0():
	# Checks which direction
	if self.rotation.x < 0:
		# Rotates to 0 at the speed defined above
		self.rotation.x += deg_to_rad(rAccelX)
		# Sets to 0 if it's gone above.
		if self.rotation.x > 0:
			self.rotation.x = 0
	
	elif self.rotation.x > 0:
		# Rotates to 0 at the speed defined above
		self.rotation.x -= deg_to_rad(rAccelX)
		# Sets to 0 if it's gone below.
		if self.rotation.x < 0:
			self.rotation.x = 0



# Functions doesn't work. Get back to it if you want to
#func rotate_to_0(axis, accel):
	#if axis < 0:
		## Rotates to 0 at the speed defined above
		#axis += deg_to_rad(accel)
		#if axis > 0:
			#axis = 0
	#
	#elif axis > 0:
		#axis -= deg_to_rad(accel)
		#if axis < 0:
			#axis = 0
