extends Node2D
# Controla a distância para criar o próximo item
var proximo_spawn_z : float = 1000.0
# Logica da pista
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

# Variavel da posicao da pista
var width := 1024
var heigth := 600
var road_width := 2000
var seg := 200
var cam := 0.85
var lines := []
var pos := 0
var num
var skyline_pos := 0.0
var skyline_h := 0

# Variavel de direcao
var road_length := 2000
var direction := 0

@onready var skyline: Sprite2D = $CapturaDeTela20260515012241

# --- NOVO: REFERÊNCIA PARA AS SUAS CENAS DE ITENS ---
var cena_saudavel = preload("res://scenes/saudavel.tscn")
var cena_naosaudavel = preload("res://scenes/naosaudavel.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(road_length):
		# ADAPTADO: Adicionado a chave "objects": [] para guardar os itens de cada linha
		lines.append({x=0, y=0, z=0, px=0, py=0, pw=0, scale = 0, curve = 0, objects = []})
		lines[i].z = i * seg + 0.00000001
		
		if i > 300 and i < 700: lines[i].curve = 0.5
		if i > 800 and i < 1200: lines[i].curve = -0.7
		if i < 755: lines[i].y = sin(i/30.0) * 600
		
	num = lines.size()
	

	
func _process(delta: float) -> void:
	queue_redraw()
	
	direction = Input.get_axis("ui_down","ui_up")
	pos += seg * direction
	
	# Se o jogador estiver correndo para frente, gerencia o spawn
	if direction > 0:
		var cam_z = pos
		# Se a câmera passou do ponto de spawn planejado, cria um item no horizonte
		if cam_z + 40000 > proximo_spawn_z:
			_spawn_item_no_horizonte(proximo_spawn_z)
			# Planeja o próximo item para 4000 a 8000 unidades adiante (20 a 40 segmentos)
			proximo_spawn_z += randf_range(4000, 8000)

# Nova função que cria o item diretamente atrelado ao número do segmento correto
func _spawn_item_no_horizonte(z_pos: float) -> void:
	var item_segmento = int(z_pos / seg) % num
	
	var novo_item
	if randi() % 2 == 0:
		novo_item = cena_saudavel.instantiate()
	else:
		novo_item = cena_naosaudavel.instantiate()
		
	# Define a linha exata em que ele vai ficar preso
	novo_item.segment_index = item_segmento
	novo_item.offset_x = randf_range(-0.5, 0.5)
	
	
	novo_item.z_index = 5 # Garante que ele seja desenhado por cima da estrada
	
	# IMPORTANTE: Adiciona o item como filho direto da cena para que herde a renderização global
	add_child(novo_item)
	
	# Guarda a referência na nossa estrutura de dados da pista
	lines[item_segmento].objects.append(novo_item)




func _draw_road(color: Color, x1: float, y1: float, w1: float, x2: float, y2: float, w2: float) -> void:
	var a = Vector2(x1 - w1, y1)
	var b = Vector2(x2 - w2, y2)
	var c = Vector2(x2 + w2, y2)
	var d = Vector2(x1 + w1, y1)
	
	var points = PackedVector2Array([a, b, c, d])
	draw_colored_polygon(points, color)


func _line(line, cam_x, cam_y, cam_z):
	line.scale = cam / (line.z - cam_z)
	line.px = (1 + line.scale * (line.x - cam_x)) * width / 2 
	line.py = (1 - line.scale * (line.y - cam_y)) * heigth / 2 
	line.pw = line.scale * road_width * (width/2)              
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
			# ADAPTADO: Mesmo que o asfalto não desenhe por otimização, 
			# garante que os objetos sumidos fiquem invisíveis se passarem da tela
			for obj in l.objects:
				if is_instance_valid(obj):
					obj.visible = false
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
		
		# --- RENDERIZAÇÃO ATUALIZADA COM ESCALA FORÇADA ---
		for obj in l.objects:
			if is_instance_valid(obj):
				# Calcula a posição baseada na linha da pista
				var item_x = l.px + (l.scale * obj.offset_x * road_width * (width / 2.0))
				var item_y = l.py
				
				obj.global_position = Vector2(item_x, item_y)
				
				# 1. Multiplicamos a escala da câmera por um valor bem mais agressivo (2200.0)
				# 2. Mantemos uma base inicial visível lá no fundo (+ 0.2)
				var fator_escala = (l.scale * 2200.0) + 0.2
				
				# Ajustamos o limite máximo para 6.0 para permitir que ele fique 
				# grande e satisfatório bem na cara do jogador antes de sumir
				fator_escala = min(fator_escala, 6.0)
				
				obj.global_scale = Vector2(fator_escala, fator_escala)
				
				# Forçamos a visibilidade como TRUE para testar se eles estão na tela
				obj.visible = true
			else:
				l.objects.erase(obj)
