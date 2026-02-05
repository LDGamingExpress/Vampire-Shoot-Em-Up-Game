extends Node2D
var Biome = "Continental"
var Tiles = []
var TileBiomes = []
var WorldWidth = 10
var WorldHeight = 10
var TileAllow = [
	[0,1],
	[0,1,2,1,2],
	[1,2,3,1,2,2,1,2,1,2,1,2],
	[2,3,4,2,2],
	[3,4,4,4,4,4,4]
]

func _ready() -> void:
	WorldHeight = int(Globals.ScreenSize.y * 1.2 / 32 + 1)
	WorldWidth = int(Globals.ScreenSize.x * 1.2 / 32 + 1)
	
	
	for y in range(0, WorldHeight):
		var TempMat = []
		var BiomeMat = []
		for x in range(0, WorldWidth):
			if y == 0 and x == 0:
				TempMat.append(randi_range(0,4))
			else:
				if y == 0:
					var AllowedTypes = TileAllow[TempMat[x - 1]].duplicate_deep()
					TempMat.append(AllowedTypes.pick_random())
				else:
					if x == 0:
						var AllowedTypes = TileAllow[Tiles[y - 1][0]].duplicate_deep()
						TempMat.append(AllowedTypes.pick_random())
					else:
						var AllowedTypes = TileAllow[Tiles[y - 1][x]].duplicate_deep()
						var NewAllowedTypes = TileAllow[TempMat[x - 1]].duplicate_deep()
						var i = 0
						#print(TileAllow)
						while i < len(AllowedTypes) and len(AllowedTypes) > 0:
							#print(AllowedTypes)
							if !NewAllowedTypes.has(AllowedTypes[i]):
								AllowedTypes.erase(AllowedTypes[i])
								i -= 1
							i += 1
							#print(i)
							#print(len(AllowedTypes))
						AllowedTypes.append_array(NewAllowedTypes)
						TempMat.append(AllowedTypes.pick_random())
			BiomeMat.append(Biome)
		Tiles.append(TempMat)
		TileBiomes.append(BiomeMat)
	Redraw()

func Redraw():
	for y in range(0, WorldHeight):
		for x in range(0, WorldWidth):
			var BiomeOffset = 0
			match TileBiomes[y][x]:
				"Continental":
					BiomeOffset = 0
				"Desert":
					BiomeOffset = 3
				"Arctic":
					BiomeOffset = 6
			$TileMapLayer.set_cell(Vector2i(x - WorldWidth/2,y - WorldHeight/2),0,Vector2i(Tiles[y][x],BiomeOffset + randi_range(0,2)))

func _physics_process(delta: float) -> void:
	$TileMapLayer.position.y += Globals.PlayerSpeed*delta
	if $TileMapLayer.position.y > 32.0:
		$TileMapLayer.position.y -= 32.0
		
		# Shift:
		var y = WorldHeight - 1
		while y > 0:
			Tiles[y] = Tiles[y - 1]
			TileBiomes[y] = TileBiomes[y - 1]
			y -= 1
		
		# Generate new row:
		var TempMat = []
		var BiomeMat = []
		for x in range(0, WorldWidth):
			if x == 0:
				var AllowedTypes = []
				match Tiles[1][0]:
					0:
						AllowedTypes = [0,1,1,0]
					1:
						AllowedTypes = [0,1,2,1,2]
					2:
						AllowedTypes = [1,2,3,1,2]
					3:
						AllowedTypes = [2,3,4,2]
					4:
						AllowedTypes = [3,4]
				TempMat.append(AllowedTypes.pick_random())
			else:
				var AllowedTypes = []
				match Tiles[1][x]:
					0:
						AllowedTypes = [0,1,1,0]
					1:
						AllowedTypes = [0,1,2,1,2]
					2:
						AllowedTypes = [1,2,3,1,2]
					3:
						AllowedTypes = [2,3,4,2]
					4:
						AllowedTypes = [3,4]
				match TempMat[x - 1]:
					0:
						AllowedTypes.erase(2)
						AllowedTypes.erase(3)
						AllowedTypes.erase(4)
						AllowedTypes.append(0)
						AllowedTypes.append(1)
						AllowedTypes.append(0)
						AllowedTypes.append(1)
					1:
						AllowedTypes.erase(3)
						AllowedTypes.erase(4)
						AllowedTypes.append(0)
						AllowedTypes.append(1)
						AllowedTypes.append(2)
						AllowedTypes.append(1)
						AllowedTypes.append(2)
					2:
						AllowedTypes.erase(0)
						AllowedTypes.erase(4)
						AllowedTypes.append(1)
						AllowedTypes.append(2)
						AllowedTypes.append(3)
						AllowedTypes.append(1)
						AllowedTypes.append(2)
					3:
						AllowedTypes.erase(0)
						AllowedTypes.erase(1)
						AllowedTypes.append(2)
						AllowedTypes.append(3)
						AllowedTypes.append(4)
						AllowedTypes.append(2)
					4:
						AllowedTypes.erase(0)
						AllowedTypes.erase(1)
						AllowedTypes.erase(2)
						AllowedTypes.append(3)
						AllowedTypes.append(4)
				TempMat.append(AllowedTypes.pick_random())
			BiomeMat.append(Biome)
		Tiles[0] = TempMat
		TileBiomes[0] = BiomeMat
		Redraw()
