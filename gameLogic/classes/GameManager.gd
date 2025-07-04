extends Node
class_name GameManager

static var players: Array[AbstractPlayer] = []


#Return value is to wait the load of all elements and check if we got an error during the loading
static func loadGame() -> bool : 
	#Load all units from all player into players and place them on the map(and setup their effects?)
	
	return true


static func getAllUnits() -> Array[AbstractUnit] :
	var units: Array[AbstractUnit] = []
	for player: AbstractPlayer in players: 
		units.append_array(player.getUnits())
	return units

static func getUnits(team: TeamsColor.TeamsColor) -> Array[AbstractUnit] :
	for player: AbstractPlayer in players: 
		if(player.team == team):
			return player.getUnits()
	return []


static func getPlayer(team: TeamsColor.TeamsColor) -> AbstractPlayer :
	for player: AbstractPlayer in players: 
		if(player.team == team):
			return player
	return null

static func whenUnitPlace(unit: AbstractUnit) -> void :
	var units = getAllUnits()
	for _unit: AbstractUnit in units:
		if(_unit.uid != unit.uid):#Avoid to count 2 time the same effect for the unit which spawn
			_unit.onUnitPlace(unit)

static func fight(unitAttacking: AbstractUnit, unitAttacked: AbstractUnit) -> void:
	if(unitAttacked.hpActual <= 0):
		return
	var damageType: DamageTypes.DamageTypes = unitAttacking.damageType
	var damageBase: int = unitAttacking.onDamageDealed(unitAttacked, damageType)
	var infoDamagesTaked  = unitAttacked.onDamageTaken(unitAttacking, damageBase, damageType, false)
	print("DAMAGE TAKED: "+ str(infoDamagesTaked["damage"]))
	#We resolve cases when the attacker died while attacking
	if(unitAttacking.hpActual <= 0):
		unitAttacked.onKill(unitAttacking)
		unitAttacking.onDeath(unitAttacked)
		if(infoDamagesTaked["hpActual"] == 0):
			unitAttacking.onKill(unitAttacked)
			unitAttacked.onDeath(unitAttacking)
	#We also check if the unit attacked has survived or not
	elif(infoDamagesTaked["hpActual"] == 0):
		unitAttacking.onKill(unitAttacked)
		unitAttacked.onDeath(unitAttacking)
		if(unitAttacking.hpActual <= 0):
			unitAttacked.onKill(unitAttacking)
			unitAttacking.onDeath(unitAttacked)
	

static func savingGame() -> void :
	
	var gameData := {
		"turnData": {},
		"players": []
	}
	for player in players :
		gameData["players"].append(player.registerPlayer())
	
	var json = JSON.new()
	json = json.stringify(gameData)
