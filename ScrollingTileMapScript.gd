extends Node2D
var Biome = "Continental"
var Tiles = []
var BuildingTiles = []
var BuildingTileYOffsets = []
var TileBiomes = []
var WorldWidth = 10
var WorldHeight = 10
var TileAllow = [
	[0,0,0,0,0,1],
	[0,1,2,1,2],
	[1,2,3,1,2,2,1,2,1,2,1,2],
	[2,3,4,2,2,2,2],
	[3,4,4,4]
]

func GenerateNew() -> void:
	Biome = Globals.Biome
	
	WorldHeight = int(Globals.ScreenSize.y * 1.2 / 32 + 1)
	WorldWidth = int(Globals.ScreenSize.x * 1.2 / 32 + 1)
	
	$NightLayer.polygon = PackedVector2Array([Vector2(-Globals.ScreenSize.x/2,Globals.ScreenSize.y/2),Vector2(Globals.ScreenSize.x/2,Globals.ScreenSize.y/2),Vector2(Globals.ScreenSize.x/2,-Globals.ScreenSize.y/2),Vector2(-Globals.ScreenSize.x/2,-Globals.ScreenSize.y/2)])
	
	for y in range(0, WorldHeight):
		var TempMat = []
		var BiomeMat = []
		var BuildingMat = []
		var BuildingYMat = []
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
						var AllowedTypes2 = TileAllow[Tiles[y - 1][x]].duplicate_deep()
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
						while i < len(NewAllowedTypes) and len(NewAllowedTypes) > 0:
							#print(AllowedTypes)
							if !AllowedTypes2.has(NewAllowedTypes[i]):
								NewAllowedTypes.erase(NewAllowedTypes[i])
								i -= 1
							i += 1
							#print(i)
							#print(len(AllowedTypes))
						AllowedTypes.append_array(NewAllowedTypes)
						if len(AllowedTypes) < 1:
							AllowedTypes = [2]
						TempMat.append(AllowedTypes.pick_random())
			BiomeMat.append(Biome)
			var BuildingChanceMult = 0
			match Biome:
				"Continental":
					BuildingChanceMult = 1.0
				"Desert":
					BuildingChanceMult = 0.25
				"Arctic":
					BuildingChanceMult = 0.05
			var BuildingChance = 0
			if TempMat[len(TempMat)-1] == 0:
				BuildingChance = 30
			elif TempMat[len(TempMat)-1] == 1:
				BuildingChance = 20
			elif TempMat[len(TempMat)-1] == 2:
				BuildingChance = 10
			if BuildingChance * BuildingChanceMult > randi_range(0,100):
				BuildingMat.append(randi_range(0,4))
			else:
				BuildingMat.append(-1)
			var PlanetTypeOffset = 0
			match Globals.PlanetType:
				"Alive":
					PlanetTypeOffset = randi_range(0,1)
				"Dead":
					PlanetTypeOffset = randi_range(1,2)
				"Mixed":
					PlanetTypeOffset = randi_range(0,2)
			BuildingYMat.append(PlanetTypeOffset)
		Tiles.append(TempMat)
		TileBiomes.append(BiomeMat)
		BuildingTiles.append(BuildingMat)
		BuildingTileYOffsets.append(BuildingYMat)
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
			$TileMapLayer2.set_cell(Vector2i(x - WorldWidth/2,y - WorldHeight/2),1,Vector2i(BuildingTiles[y][x],BuildingTileYOffsets[y][x] + 9))

func _physics_process(delta: float) -> void:
	Biome = Globals.Biome
	$TileMapLayer.position.y += Globals.PlayerSpeed*delta
	$TileMapLayer2.position.y += Globals.PlayerSpeed*delta
	if $TileMapLayer.position.y > 32.0:
		$TileMapLayer.position.y -= 32.0
		$TileMapLayer2.position.y -= 32.0
		
		# Shift:
		var y = WorldHeight - 1
		while y > 0:
			Tiles[y] = Tiles[y - 1]
			TileBiomes[y] = TileBiomes[y - 1]
			BuildingTiles[y] = BuildingTiles[y - 1]
			BuildingTileYOffsets[y] = BuildingTileYOffsets[y - 1]
			y -= 1
		
		# Generate new row:
		var TempMat = []
		var BiomeMat = []
		var BuildingMat = []
		var BuildingYMat = []
		for x in range(0, WorldWidth):
			if x == 0:
				var AllowedTypes = TileAllow[Tiles[1][0]].duplicate_deep()
				TempMat.append(AllowedTypes.pick_random())
			else:
				var AllowedTypes = TileAllow[Tiles[1][x]].duplicate_deep()
				var AllowedTypes2 = TileAllow[Tiles[1][x]].duplicate_deep()
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
				while i < len(NewAllowedTypes) and len(NewAllowedTypes) > 0:
					#print(AllowedTypes)
					if !AllowedTypes2.has(NewAllowedTypes[i]):
						NewAllowedTypes.erase(NewAllowedTypes[i])
						i -= 1
					i += 1
					#print(i)
					#print(len(AllowedTypes))
				AllowedTypes.append_array(NewAllowedTypes)
				if len(AllowedTypes) < 1:
					AllowedTypes = [2]
				TempMat.append(AllowedTypes.pick_random())
			BiomeMat.append(Biome)
			var BuildingChanceMult = 0
			match Biome:
				"Continental":
					BuildingChanceMult = 1.0
				"Desert":
					BuildingChanceMult = 0.25
				"Arctic":
					BuildingChanceMult = 0.05
			var BuildingChance = 0
			if TempMat[len(TempMat)-1] == 0:
				BuildingChance = 30
			elif TempMat[len(TempMat)-1] == 1:
				BuildingChance = 20
			elif TempMat[len(TempMat)-1] == 2:
				BuildingChance = 10
			if BuildingChance * BuildingChanceMult > randi_range(0,100):
				BuildingMat.append(randi_range(0,4))
			else:
				BuildingMat.append(-1)
			var PlanetTypeOffset = 0
			match Globals.PlanetType:
				"Alive":
					PlanetTypeOffset = randi_range(0,1)
				"Dead":
					PlanetTypeOffset = randi_range(1,2)
				"Mixed":
					PlanetTypeOffset = randi_range(0,2)
			BuildingYMat.append(PlanetTypeOffset)
		Tiles[0] = TempMat
		TileBiomes[0] = BiomeMat
		BuildingTiles[0] = BuildingMat
		BuildingTileYOffsets[0] = BuildingYMat
		Redraw()
