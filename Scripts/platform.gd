extends Node


@export_dir var platformPath = "res://Platforms"
@onready var scoreLabel = %Score


var platformScenes: Array = []

var conveyerBelt: Array[MeshInstance3D] = []

var cbSize = 4
var speed = 20
var score = 0
func _ready():
	load_platforms(platformPath)
	var len = 0
	for i in range(cbSize):
		var platform = platformScenes.pick_random().instantiate()
		platform.position.z = len
		len -= platform.get_aabb().size.z
		# print(platform.position.z)
		add_child(platform)
		conveyerBelt.append(platform)
	pass
	
func _process(delta):
	for platform in conveyerBelt:
		platform.position.z += speed * delta
		score = score + (speed * delta / 10)
		scoreLabel.text = "Distance Travelled: %d" % score
	
	if int(score) % 100 == 99:
		speed += .2
	if conveyerBelt[0].position.z >= conveyerBelt[0].get_aabb().size.z:
		var lastP = conveyerBelt[-1]
		
		var p = platformScenes.pick_random().instantiate()
		p.position.z = lastP.position.z - lastP.get_aabb().size.z
		add_child(p)
		conveyerBelt.append(p)
		conveyerBelt.pop_front().queue_free()
		pass
	pass
	
	
func load_platforms(platformPath):
	var dir = DirAccess.open(platformPath)
	for scenePath in dir.get_files():
		print("Loading terrian block scene: " + platformPath + "/" + scenePath)
		platformScenes.append(load(platformPath + "/" + scenePath))
