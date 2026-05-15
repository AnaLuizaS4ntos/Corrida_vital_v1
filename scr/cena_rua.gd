extends Node2D


#logica da pista
var color := {
	"grass_dark" :Color(0.22, 0.447, 0.0, 1.0),
	"grass_light" :Color(0.179, 0.6, 0.0, 1.0),
	"border_dark" :Color(0.094, 0.093, 0.255, 1.0),
	"border_light" :Color(0.177, 0.171, 0.379, 1.0),
	"road_dark" :Color(0.4, 0.4, 0.4),
	"strip_dark" :Color(0.667, 0.133, 0.0, 0.0),
	"strip_light" :Color(1, 1, 1),
	"road_light" :Color(0.343, 0.339, 0.352, 1.0)
}

#variavel da posicao da pista
var width :=1024
var heigth := 600
var road_width := 2000
var seg := 200
var cam := 0.85
var lines := []
var pos := 0
var num
var skyline_pos := 0.0
var skyline_h := 0


#variavel de direcao
var road_length := 2000
var direction := 0

@onready var skyline: Sprite2D = $CapturaDeTela20260515012241


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(road_length):
		# px, py, pw 
		lines.append({x=0, y=0, z=0, px=0, py=0, pw=0, scale = 0, curve = 0})
		lines[i].z = i * seg + 0.00000001
		
		if i > 300 and i < 700: lines[i].curve = 0.5
		if i > 800 and i < 1200: lines[i].curve = -0.7
		if i < 755: lines[i].y = sin(i/30.0) *600
		
	num = lines.size()
	
func _process(delta: float) -> void:
	queue_redraw()
	
	direction = Input.get_axis("ui_down","ui_up")
	pos += seg * direction
	
func _draw_road(color: Color, x1: float, y1: float, w1: float, x2: float, y2: float, w2: float) -> void:
	# Definindo os 4 pontos do trapézio (A, B, C, D)
	var a = Vector2(x1 - w1, y1)
	var b = Vector2(x2 - w2, y2)
	var c = Vector2(x2 + w2, y2)
	var d = Vector2(x1 + w1, y1)
	
	var points = PackedVector2Array([a, b, c, d])
	
	draw_colored_polygon(points, color)

func _line(line, cam_x, cam_y, cam_z):
	line.scale = cam / (line.z - cam_z)
	line.px = (1 + line.scale * (line.x - cam_x)) * width / 2 # Mudou de X para px
	line.py = (1 - line.scale * (line.y - cam_y)) * heigth / 2 # Mudou de Y para py
	line.pw = line.scale * road_width * (width/2)             # Mudou de W para pw
	return line
	



func _draw() -> void:
	if pos >= num * seg:
		pos -= num * seg
	
	if pos < 0:
		pos += num * seg
		
	var num_pos = 0
	var start_point = int(pos / seg)
	var cam_h = 1000 + lines[start_point % num].y
	var cutoff = heigth
	var x = 0.0
	var dx = 0.0
	
	skyline_pos += lines[start_point % num].curve * 2.0 * direction
	skyline_h = -lines[start_point % num].y * 0.005
	skyline.set_region_rect(Rect2(skyline_pos, skyline_h, 1920, 320))
	
	for n in range(start_point, start_point + 300):
		if n >= num:
			num_pos = num * seg
		else:
			num_pos = 0
			
		var l = lines[n % num]
		_line(l, x, cam_h, pos - num_pos)
		
		var p = lines[(n - 1) % num]
		
		x += dx
		dx += l.curve
		
		if l.py >= cutoff:
			continue
		
		cutoff = l.py
		
		var is_dark = n % 6 < 3
		var road_col = color["road_dark"] if is_dark else color["road_light"]
		var grass_col = color["grass_dark"] if is_dark else color["grass_light"]
		
		draw_rect(Rect2(0, p.py, width, l.py - p.py), grass_col)
		_draw_road(road_col, p.px, p.py, p.pw, l.px, l.py, l.pw)
		
		var border = color["border_dark"] if (int(n / 4) % 2) else color["border_light"]
		var road   = color["road_dark"]   if (int(n / 4) % 2) else color["road_light"]
		var grass  = color["grass_dark"]  if (int(n / 8) % 2) else color["grass_light"]
		var strip  = color["strip_dark"]  if (int(n / 8) % 2) else color["strip_light"]
		 
		_draw_road(grass, 0, p.py, width, 0, l.py, width)
		_draw_road(border, p.px, p.py, p.pw*1.2, l.px, l.py, l.pw * 1.2)
		_draw_road(road_col, p.px, p.py, p.pw, l.px, l.py, l.pw)
		_draw_road(strip, p.px, p.py, p.pw*0.01, l.px, l.py, l.pw * 0.01)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
