extends Camera3D

@onready var ship = %Ship

var pos = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pos = position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = ship.position.x * .8
	position.y = (ship.position.y + pos) * .8
	pass
