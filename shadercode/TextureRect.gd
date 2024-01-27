extends TextureRect

#variable declarations
var shaderIntensity = material.get_shader_parameter("intensity")
var targetIntensities : Array = []  # circular queue for target_intensity
var queueSize : int = 10  # size of the circular queue
var timeUpdate = randf_range(1.0, 5.0)  # time between transitions is 1 or 5 seconds
var transition = 1.0
var timer = 0.0
var targetIntensity = shaderIntensity

func _ready():
	#sets shader intensity
	material.set_shader_parameter("intensity", shaderIntensity)

#binary search function to ensure uniqueness of intensity
func binary_search_intensity(target: float) -> bool:
	#defines left side and right side index of queue
	var left = 0
	var right = targetIntensities.size() - 1
	
	#looping through queue
	while left <= right:
		#defines middle of queue
		var mid = (left + right) / 2
		var midIntensity = targetIntensities[mid]
		
		if midIntensity == target:
			return true
		elif midIntensity < target:
			left = mid + 1
		else:
			right = mid - 1
	
	return false

#generates a unique random intensity over 10 variations
func get_unique_random_intensity() -> float:
	var newIntensity = randf()
	
	#use binary search to find a unique intensity
	while targetIntensities.size() >= queueSize and binary_search_intensity(newIntensity):
		newIntensity = randf()
	
	#use binary search to find the correct position to insert the new intensity
	var insertIndex = 0
	var left = 0
	var right = targetIntensities.size() - 1
	
	while left <= right:
		var mid = (left + right) / 2
		var midIntensity = targetIntensities[mid]
		
		if midIntensity < newIntensity:
			left = mid + 1
		else:
			right = mid - 1
			insertIndex = mid
	
	#insert the new intensity at the correct position
	targetIntensities.insert(insertIndex, newIntensity)
	
	#remove the first element if the queue exceeds its size limit of 10
	while targetIntensities.size() > queueSize:
		targetIntensities.remove_at(0)

	return newIntensity

func _process(delta):
	timer += delta
	
	#when the timer reaches the point to update, get a new unique intensity
	if timer >= timeUpdate:
		targetIntensity = get_unique_random_intensity()
		timer = 0.0
		timeUpdate = randf_range(1.0, 5.0)
	
	#clamps the transition so it cannot exceed the bounds, then interpolates the values
	#to provide a clean transition
	var clamp = clamp(timer / transition, 0.0, 1.0)
	shaderIntensity = lerp(shaderIntensity, targetIntensity, clamp)
	material.set_shader_parameter("intensity", shaderIntensity)
