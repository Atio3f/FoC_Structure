extends Node
#Contains all tests for the functional part of the game logic

func _ready():
	
	GameManager.generateMap(20, 20)
	#testFightMonkey1()
	#testHealOnKill()
	#testGodMonkeyEffectsWorked()
	#testMonteeNiveau()
	#testSaveDatas()
	#testTemporalSnail()
	#testAbominationMonkeyEffects()
	#testItemVitalLinkWork()
	testItemBrambleGauntletWork()

#Test qui permet de savoir si on peut bien créer 2 joueurs avec 2 unités chacun en vérifiant l'activation de leurs effets de placement
#et faire des combats jusqu'à la mort en vérifiant que certains effets s'activent à la mort
func testFightMonkey1():
	#On crée les joueurs
	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	print(player1.getUnits())
	#On crée l'unité du joueur 1
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:Monkey", player1, DesertTile.new(1, 1))
	var unit3: AbstractUnit = GameManager.placeUnitForTest("test:Monkey", player1, DesertTile.new(1, 2))
	
	print("unité 1 " + str(unit1.uid))
	print("unité 3 " + str(unit3.uid))
	
	#On crée l'unité du joueur 2
	var unit2: AbstractUnit = GameManager.placeUnitForTest("test:Monkey", player2, DesertTile.new(1, 3))
	print("unité 2 " + str(unit2.uid))
	var unit4: AbstractUnit = GameManager.placeUnitForTest("test:Monkey", player2, DesertTile.new(2, 1))
	print("unité 4 " + str(unit4.uid))
	print("DEBUT FIGHT")
	#On simule des combats jusqu'à la mort
	print("Power Monkey before fight"+ str(unit1.getPower()))
	assert(unit1.getPower() == unit1.powerBase + 6)
	GameManager.fight(unit4, unit3)
	print(unit3.hpActual)
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	GameManager.fight(unit4, unit3)
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	print(unit3.hpActual)
	GameManager.fight(unit4, unit3)
	print(unit3.hpActual)
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	print("Power Monkey after all fights"+ str(unit1.getPower()))
	GameManager.fight(unit4, unit3)
	print(unit3.hpActual)
	print("Power Monkey after all fights"+ str(unit1.getPower()))
	print(unit1.powerBase + 2)
	assert(unit1.getPower() == unit1.powerBase + 3)

func testHealOnKill():
	#On crée les joueurs
	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	#On crée l'unité du joueur 1
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:KnightMonkey", player1, DesertTile.new(1, 2))
	#On crée l'unité du joueur 2
	var unit2: AbstractUnit = GameManager.placeUnitForTest("test:BerserkerBull", player2, DesertTile.new(1, 1))
	
	#On simule un combat du taureau berserk qui attaque le singe
	GameManager.fight(unit1, unit2)
	var hpBull = unit2.hpActual
	print(hpBull)
	GameManager.fight(unit2, unit1)
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	GameManager.fight(unit2, unit1)
	#print("PV"+str(unit2.hpActual))
	assert(unit2.hpActual == (hpBull + (unit2.hpBase / 2) + 10))
	assert(unit1.isDead)
	print(unit2.xp)


func testGodMonkeyEffectsWorked() -> void:
	#On crée les joueurs

	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	
	#On crée l'unité du joueur 1
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:GodMonkey", player1, DesertTile.new(1, 1))
	assert(unit1.speed == 22)
	#On crée l'unité du joueur 2
	var unit2: AbstractUnit = GameManager.placeUnitForTest("test:KnightMonkey", player1, DesertTile.new(1, 2))
	assert(unit1.speed == 23)
	var unit3: AbstractUnit = GameManager.placeUnitForTest("test:BerserkerBull", player2, DesertTile.new(2, 1))
	#On simule un combat du taureau berserk qui attaque le singe
	GameManager.fight(unit3, unit2)
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	GameManager.fight(unit3, unit2)
	assert(unit2.isDead)
	#Speed of god Monkey decrease when a Monkey dies
	assert(unit1.speed == 22)

func testMonteeNiveau():
	#On crée les joueurs

	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	TurnManager.addTeam(player1.team)
	TurnManager.addTeam(player2.team)
	#On crée l'unité du joueur 1
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:KnightMonkey", player2, DesertTile.new(1, 1))
	#On crée l'unité du joueur 2 qu'on va faire monter de niveau
	var unit2: AbstractUnit = GameManager.placeUnitForTest("test:BerserkerBull", player2, DesertTile.new(1, 2))
	#On simule un combat du taureau berserk qui attaque les 2 singes pour les tuer
	var lvlBull = unit2.level
	GameManager.fight(unit2, unit1)
	print(unit2.xp)
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	GameManager.fight(unit2, unit1)
	print(unit2.xp)
	assert(unit2.level == 2)
	assert(unit2.hpMax == unit2.hpBase * 1.5)

#Permet de s'assurer qu'on peut sauvegarder les données d'une partie pour la reprendre plus tard
func testSaveDatas() -> void:
	GameManager.deleteAllSaves()
	#On crée les joueurs

	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:KnightMonkey", player1, DesertTile.new(1, 3))
	GameManager.savingGame()
	GameManager.loadSave(1)
	var players: Array = GameManager.getPlayers()
	var player1S: AbstractPlayer = players[0]
	var player2S: AbstractPlayer = players[1]
	var unit1S: AbstractUnit = player1S.getUnits()[0]

#Test de l'escargot temporel + du nouveau moyen de créer des unités en une fonction
func testTemporalSnail() -> void:
	#On crée les joueurs
	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:KnightMonkey", player1, DesertTile.new(4, 1))
	var unit2: AbstractUnit = GameManager.placeUnitForTest("test:TemporalSnail", player2, DesertTile.new(1, 1))
	print(unit2.getPower())
	GameManager.fight(unit2, unit1)
	TurnManager.nextTurn()
	GameManager.fight(unit2, unit1)
	print(unit2.xp)
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	GameManager.fight(unit2, unit1)
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	GameManager.fight(unit2, unit1)
	print(unit2.xp)
	print(unit2.level)
	

func testAbominationMonkeyEffects() -> void :
	#On crée les joueurs
	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:KnightMonkey", player1, ForestTile.new(1, 1))
	var unit2: AbstractUnit = GameManager.placeUnitForTest("test:AbominationMonkey", player2, DesertTile.new(1, 2))
	var expectedDmg: int = unit2.getPower()
	GameManager.fight(unit2, unit1)
	print(expectedDmg)
	assert(unit1.hpActual == (unit1.hpMax - expectedDmg))
	TurnManager.nextTurn()
	TurnManager.nextTurn()
	assert(unit1.hpActual == (unit1.hpMax - expectedDmg + 13))


func testItemVitalLinkWork() -> void:
	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:KnightMonkey", player1, ForestTile.new(1, 1))
	var unit2: AbstractUnit = GameManager.placeUnitForTest("test:AbominationMonkey", player2, DesertTile.new(1, 2))
	
	player1.addCard("test:VitalLink")
	assert(player1.getCards().size() == 1)
	assert(player1.cardPlayable("test:VitalLink") == []) #Check que la carte est injouable pour l'instant
	GameManager.fight(unit2, unit1)
	var hpKnight : int = unit1.hpActual
	assert(player1.cardPlayable("test:VitalLink") != [])
	player1.useCard("test:VitalLink", [unit1])
	assert(player1.getCards().size() == 0)	#L'objet a bien été consommé
	assert(unit1.hpActual == hpKnight + 10)	#L'objet a bien affecté l'unité

func testItemBrambleGauntletWork() -> void:
	var player1: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.CYAN, "player1")
	var player2: AbstractPlayer = GameManager.createPlayer(TeamsColor.TeamsColor.RED, "player2")
	
	var unit1: AbstractUnit = GameManager.placeUnitForTest("test:KnightMonkey", player1, ForestTile.new(1, 1))
	var unit2: AbstractUnit = GameManager.placeUnitForTest("test:AbominationMonkey", player2, DesertTile.new(1, 2))
	
	player1.addCard("test:BrambleGauntlet")
	assert(player1.getCards().size() == 1)
	assert(player1.cardPlayable("test:BrambleGauntlet") == []) #Check que la carte est injouable pour l'instant
	var hpAbomination : int = unit2.hpActual
	var speedAbomination : int = unit2.speed
	var unit3: AbstractUnit = GameManager.placeUnitForTest("test:BlueMushroom", player1, ForestTile.new(1, 1))
	assert(player1.cardPlayable("test:BrambleGauntlet") != [])
	player1.useCard("test:BrambleGauntlet", [unit3])
	assert(player1.getCards().size() == 0)
	GameManager.fight(unit3, unit2)
	#Assert damage augments et vitesse réduite
	assert(unit2.hpActual == hpAbomination - 4)
	assert(unit2.speed == speedAbomination - 3)
