extends Node

var game_running : bool			# <- To check game state
var game_over : bool				# <- To check game state
var scroll						# <- Technically for parallax effect
var score						# <- To track score
const SCROLL_SPEED : int = 4		# <- To adjust game speed
var screen_size : Vector2i		#
var ground_height : int			#
var pipes : Array				# <- To store all the pipes created
const PIPE_DELAY : int = 100		# <- To control how long until next pipe
const PIPE_RANGE : int = 200		# <- To control position of pipes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()
	
func new_game():
	game_running = false
	game_over = false
	scroll = 0
	score = 0
	$Bird.reset()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		scroll += SCROLL_SPEED
		# Reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		# Move ground node
		$Ground.position.x = -scroll
