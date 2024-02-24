class_name LithoImage

#enum ImageRotation {
	#ROTATE_O = 0,
	#ROTATE_90 = 1,
	#ROTATE_180 = 2,
	#ROTATE_270 = 3
#}

var is_negative: bool
var is_flip_x: bool
var is_flip_y: bool
var current_angle: int
var image: Image

func _init(img: Image):
	is_negative = false
	is_flip_x = false
	is_flip_y = false
	current_angle = 0
	image = img
	
	#image.convert(Image.Format.FORMAT_L8)

func flip_x():
	set_flip_x( !is_flip_x )
	
func flip_y():
	set_flip_y( !is_flip_y )

func set_flip_x(flip):
	if (flip && !is_flip_x) || (!flip && is_flip_x):
		image.flip_x();
		
	is_flip_x = flip
		

func set_flip_y(flip):
	if (flip && !is_flip_y) || (!flip && is_flip_y):
		image.flip_y();
		
	is_flip_y = flip
	
func set_rotation(angle: int):
	var rotation = (angle - current_angle) / 90
	
	for _i in range(abs(rotation)):
		image.rotate_90( CLOCKWISE if rotation > 0 else COUNTERCLOCKWISE )
	
	current_angle += rotation * 90
	
	
#func set_negative(negative):
	#if (negative && !is_negative) || (!negative && is_negative):
		#for x in range(image.get_width()):
			#for y in range(image.get_height()):
				#image.set_pixel(x, y, Color.WHITE - image.get_pixel(x, y))
	#
	#is_negative = negative
	
func get_width() -> int:
	return image.get_width()
	
func get_height() -> int:
	return image.get_height()

func get_image() -> Image:
	return image

func get_pixel_value(x: int, y: int, invert: bool) -> float:
	var pixel = image.get_pixel(x, y)
	var value = 0.2126 * pixel.r + 0.7152 * pixel.g + 0.0722 * pixel.b
	
	if invert:
		return value
	else:
		return 1.0 - value
