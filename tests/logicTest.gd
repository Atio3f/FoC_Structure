extends Node
#Contains all tests for the functional part of the game logic

func _ready():
	testFightMonkey1()

#Test qui permet de savoir si on peut bien créer 2 joueurs avec 2 unités chacun en vérifiant l'activation de leurs effets de placement
#et faire des combats jusqu'à la mort en vérifiant que certains effets s'activent à la mort
func testFightMonkey1():
	#On crée les joueurs
	var player1: AbstractPlayer = AbstractPlayer.new(TeamsColor.TeamsColor.CYAN)
	var player2: AbstractPlayer = AbstractPlayer.new(TeamsColor.TeamsColor.RED)
	print(player1.getUnits())
	#On crée l'unité du joueur 1
	var unit1: AbstractUnit = Monkey.new(player1)
	unit1.onPlacement("tile:desert")
	var unit3: AbstractUnit = Monkey.new(player1)
	unit3.onPlacement("tile:desert")
	print("unité 1 " + str(unit1.uid))
	print("unité 3 " + str(unit3.uid))
	
	#On crée l'unité du joueur 2
	var unit2: AbstractUnit = Monkey.new(player2)
	print("unité 2 " + str(unit2.uid))
	unit2.onPlacement("tile:desert")
	var unit4: AbstractUnit = Monkey.new(player2)
	print("unité 4 " + str(unit4.uid))
	unit4.onPlacement("tile:desert")
	print("DEBUT FIGHT")
	#On simule des combats jusqu'à la mort
	print("Power Monkey before fight"+ str(unit1.power))
	assert(unit1.power == unit1.powerBase + 4)
	GameManager.fight(unit4, unit3)
	print(unit3.hpActual)
	GameManager.fight(unit4, unit3)
	print(unit3.hpActual)
	GameManager.fight(unit4, unit3)
	print(unit3.hpActual)
	GameManager.fight(unit4, unit3)
	print(unit3.hpActual)
	print("Power Monkey after all fights"+ str(unit1.power))
	assert(unit1.power == unit1.powerBase + 2)

func testHealOnKill():
	#On crée les joueurs
	var player1: AbstractPlayer = AbstractPlayer.new(TeamsColor.TeamsColor.CYAN)
	var player2: AbstractPlayer = AbstractPlayer.new(TeamsColor.TeamsColor.RED)
	#On crée l'unité du joueur 1
	var unit1: AbstractUnit = Monkey.new(player1)
	unit1.onPlacement("tile:desert")
	#On crée l'unité du joueur 2
	var unit2: AbstractUnit = BerserkerBull.new(player2)
	unit2.onPlacement("tile:desert")
	#On simule un combat du taureau berserk qui attaque le singe
	GameManager.fight(unit2, unit1)
