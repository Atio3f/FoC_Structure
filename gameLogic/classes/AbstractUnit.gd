extends Node
class_name AbstractUnit
#Represent a unit
static var _uid_counter := 0
static var xpPerLevel = [0, 90, 220, 400, 700, 99999]
var id: String	#Id of the unit, serve to know the id of the unit
var uid: String	#Identifiant unique créer lorsqu'on place l'unité
var imgPath: String
var grade: int
var hpActual: int
var hpMax: int
var hpBase: int
var hpTemp: int
#Manque pê encore certains trucs sur les pv
var power: int
var powerBase: int #Base value of p for the unit without any bonus or change
var damageType: DamageTypes.DamageTypes
var atkPerTurn: int = 1; #Number of attacks the unit can perform each turn
var atkRemaining: int
var atkPerTurnBase: int
var range: int
var speed: int
var speedRemaining: int	#Speed remaining for this turn
var speedBase: int #Base value of speed for the unit without any bonus or change
var dr: int	#1 point of damage resistance (against physical attacks?) = 1 less damage taken each (physical?)attack
var drBase: int #Base value of damage reduction for the unit without any bonus or change
var mr: int	#1 point of magical resistance (against magic attacks) = 1 less damage taken each magic attack
var mrBase: int #Base value of damage reduction for the unit without any bonus or change
var potential: int #VALEUR DE 2 A 5 qui définit le niveau maximal atteignable par une unité, ne peut pas être modifié normalement 
var wisdom: int	#METTRE DESC J'AI OUBLIE MDR mais c'est wisdom en tout cas
var wisdomBase: int #Base value of wisdom for the unit without any bonus or change

var level: int	#Current level
var xp: int		#Current xp

var player: AbstractPlayer
var team: TeamsColor.TeamsColor #Team Color, get from player you control him
var effects: Array[AbstractEffect] = []	#AbstractEffect pas trouvé comment le mettre dans le type
var tags: Array[Tags.tags] = []
var tile: AbstractTile	#Keep the tile where is the unit
var isDead: bool	#Allow us to keep track of units killed

var movementTypes : Array[MovementTypes.movementTypes] = []
var actualMovementTypes : MovementTypes.movementTypes = MovementTypes.movementTypes.NONE

func _init(id: String, imgPath: String, playerAssociated: AbstractPlayer, grade: int, hpBase: int, powerBase:int, damageType: DamageTypes.DamageTypes, atkPerTurnBase: int, range: int, speedBase: int, drBase: int, mrBase: int, potential: int, wisdomBase: int, idDead: bool = false):
	self.id = id
	_uid_counter += 1
	self.uid = str(randi() % 100000).pad_zeros(6) + str(Time.get_unix_time_from_system()) + str(_uid_counter)
	self.player = playerAssociated
	self.team = playerAssociated.team
	self.grade = grade
	self.hpActual = hpBase
	self.hpMax = hpBase
	self.hpBase = hpBase
	self.hpTemp = 0
	self.power = powerBase
	self.powerBase = powerBase
	self.atkPerTurn = atkPerTurnBase
	self.atkRemaining = atkPerTurnBase
	self.atkPerTurnBase = atkPerTurnBase
	self.range = range
	self.speed = speedBase
	self.speedRemaining = speedBase
	self.speedBase = speedBase
	self.drBase = drBase
	self.dr = drBase
	self.mr = mrBase
	self.mrBase = mrBase
	self.potential = potential
	self.wisdom = wisdomBase
	self.wisdomBase = wisdomBase
	self.damageType = damageType
	self.isDead = isDead
	playerAssociated.units.append(self)

func initStats(uid: String, hpMax: int, hpActual: int, hpTemp: int, power: int, speed: int, speedRemaining: int, atkPerTurn: int, atkRemaining: int, dr: int, mr: int, wisdom: int, level: int, xp: int):
	self.uid = uid
	self.hpMax = hpMax
	self.hpActual = hpActual
	self.hpTemp = hpTemp
	self.power = power
	self.speed = speed
	self.speedRemaining = speedRemaining
	self.atkPerTurn = atkPerTurn
	self.atkRemaining = atkRemaining
	self.dr = dr
	self.mr = mr
	self.wisdom = wisdom


func getPlayer() -> AbstractPlayer:
	return player

func getPower() -> int:
	return power

#Add an effect to the unit. If the unit already have the effect, it's incremented. 
#Maybe it needs to be optimized to stop the for when we pass the priority place
func addEffect(effect: AbstractEffect) -> void:
	var rank: int = 0
	var inserted: bool = false
	for _effect: AbstractEffect in effects :
		if(_effect.id == effect.id):
			if(!_effect.stackable):
				effects.insert(rank + 1, effect)
				effect.onEffectApplied(true)
			else:
				_effect.mergeEffect(effect)
			inserted = true
			break
		elif(_effect.priority > effect.priority):
			 #place effect in
			effects.insert(rank, effect)
			effect.onEffectApplied(true)
			inserted = true
			break
		rank += 1
	
	if(!inserted):
		effects.append(effect)
		effect.onEffectApplied(true)

#Maybe we will change the type of tile and register it
func onPlacement(tile: AbstractTile) -> void:
	self.tile = tile
	GameManager.whenUnitPlace(self)
	for effect: AbstractEffect in effects:
		effect.onPlacement(tile)
	tile.onUnitIn(self)

func onCardPlay(player: AbstractPlayer) -> void:
	for effect: AbstractEffect in effects:
		effect.onCardPlay(player)

func onUnitPlace(unit: AbstractUnit) -> void:
	for effect: AbstractEffect in effects:
		effect.onUnitPlace(unit)

#Tile is the actual tile after the movement
func onMovement(tile: AbstractTile) -> void:
	self.tile.onUnitOut(self)
	self.tile = tile
	tile.onUnitIn(self)
	for effect: AbstractEffect in effects:
		effect.onMovement()

#J'ai retiré item: AbstractItem,  comme param parce que pour le moment ça sert à r
func onItemUsed(player: AbstractPlayer, isMalus: bool) -> void:
	for effect: AbstractEffect in effects:
		effect.onItemUsed(player, isMalus)

#Return final damage taken, visualisation serve if we need to see damage dealed before the action
func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> Dictionary :#DamageType is an int because Gdscript is badly make and we can't place a enum which isn't the first on its file
	var damageReduction : int
	match damageType:
		DamageTypes.DamageTypes.PHYSICAL:
			damageReduction = dr
		DamageTypes.DamageTypes.MAGICAL:
			damageReduction = mr
		_:
			damageReduction = 0
	damage = 0 if (damageReduction > damage) else (damage - damageReduction)
	for effect: AbstractEffect in effects:
		damage = effect.onDamageTaken(unit, damage, damageType, visualisation)
	var hpLoses: Dictionary
	#If it's not a true attack we just return value
	if(!visualisation):
		hpLoses = loseHp(damage)
	else :
		hpLoses = getLoseHp(damage)
	return hpLoses

#Return final damage taken
func onDamageDealed(unit: AbstractUnit, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	var damage: int = getPower()
	for effect: AbstractEffect in effects:
		damage = effect.onDamageDealed(unit, damage, damageType, visualisation)
	return damage

func loseHp(damage: int) -> Dictionary:
	var hpLoses: Dictionary = getLoseHp(damage)
	hpTemp = hpLoses["hpTemp"]
	hpActual = hpLoses["hpActual"]
	return hpLoses

func getLoseHp(damage: int) -> Dictionary:
	var hpLoses: Dictionary = {}
	hpLoses["damage"] = damage
	if damage < hpTemp :
		hpLoses["hpTemp"] = hpTemp - damage
		hpLoses["hpActual"] = hpActual
	else: 
		damage -= hpTemp
		hpLoses["hpTemp"] = 0
		hpLoses["hpActual"] = (hpActual - damage) if (hpActual > damage) else 0
	return hpLoses

func onHeal(unitHealed: AbstractUnit, healValue: int) -> int :
	for effect: AbstractEffect in effects:
		healValue = effect.onHeal(unitHealed, healValue)
	return healValue

func onHealed(unitHealing: AbstractUnit, healValue: int) -> int :
	for effect: AbstractEffect in effects:
		healValue = effect.onHealed(unitHealing, healValue)
	return healValue

func healHp(healValue: int):
	if(hpActual + healValue > hpMax):
		hpActual = hpMax
	else:
		hpActual += healValue

func onKill(unitKilled: AbstractUnit) -> void :
	gainXp(ActionTypes.actionTypes.KILL, {"maxHp":unitKilled.hpMax})
	for effect: AbstractEffect in effects:
		effect.onKill(unitKilled)

func onDeath(unit: AbstractUnit = null) -> void:
	for effect: AbstractEffect in effects:
		effect.onDeath(unit)
	isDead = true	#You're not supposed to be able to survive once you're in this function

func onLevelUp() -> void :
	for effect: AbstractEffect in effects:
		effect.onLevelUp(level)
	calculateLevel()#Allow to gain multiple levels if you got enough xp

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if(turnColor == player.team):
		speedRemaining = speed
		atkRemaining = atkPerTurn
		tile.onStartOfTurn(self)
	#Est-ce qu'on bloquerait pas ça à seulement le tour du joueur avec le if?
	for effect: AbstractEffect in effects:
		effect.onStartOfTurn(turnNumber, turnColor)

#Manage all cases where an unit gain xp
func gainXp(action: ActionTypes.actionTypes, infos: Dictionary = {})-> void:
	match action:
		ActionTypes.actionTypes.ATTACK:
			xp = xp + (infos.damage * 0.75 + wisdom)
		ActionTypes.actionTypes.ATTACKED:
			xp = xp + ((infos.damage + wisdom) /2)
		ActionTypes.actionTypes.KILL:
			xp = xp + infos.maxHp + (2 * wisdom)
		_:
			1
	calculateLevel()

func calculateLevel() -> void :
	if level == potential : return	#Already level max
	if xpPerLevel[level] < xp :
		level += 1	#Set the new level
		#Reajust the stats depending of the new level reached
		match level:
			2:
				hpMax += hpBase / 2
				hpActual += hpBase / 2
				power += 3
				dr += 1
				mr += 1
				speed += 2
				wisdom += 1
			3:
				hpMax += hpBase / 2
				hpActual += hpBase / 2
				power += powerBase / 2 + 1
				dr += 3
				mr += 3
				speed += 2
				wisdom += 2
			4:
				hpMax += hpBase / 2
				hpActual += hpBase / 2
				atkPerTurn += 1
				atkRemaining += 1
				power += powerBase / 2
				dr += 4
				mr += 4
				speed += 3
				speedRemaining += 3
				wisdom += 3
			5:
				hpMax += hpBase
				hpActual += hpBase
				power += powerBase + 1
				dr += drBase + 5
				mr += mrBase + 5
				speed += 3
				speedRemaining += 3
				wisdom += 5
		onLevelUp()
	else:
		return

#We can't override get_class method from Node sadly
func getClass() -> String :
	return "AbstractUnit"

func registerUnit() -> Dictionary :
	var unitData := {
		"id": self.id,
		"imgPath": self.imgPath,
		"uid": self.uid,
		"className": get_script().resource_path.get_file().get_basename(),
		"grade": self.grade,
		"hpBase": self.hpBase,
		"hpMax": self.hpMax,
		"hpActual": self.hpActual,
		"hpTemp": self.hpTemp,
		"powerBase": self.powerBase,
		"power": self.power,
		"damageType": self.damageType,
		"atkPerTurn": self.atkPerTurn,
		"atkPerTurnBase": self.atkPerTurn,
		"atkRemaining": self.atkRemaining,
		"range": self.range,
		"speedBase": self.speedBase,
		"speed": self.speed,
		"speedRemaining": self.speedRemaining,
		"drBase": self.drBase,
		"dr": self.dr,
		"mrBase": self.mrBase,
		"mr": self.mr,
		"wisdomBase": self.wisdomBase,
		"wisdom": self.wisdom,
		"potential": self.potential,
		"level": self.level,
		"xp": self.xp,
		"tags": self.tags,
		"movementTypes": self.movementTypes,
		"actualMovementTypes": self.actualMovementTypes,
		"tile": self.tile,
		"isDead": self.isDead,
		"effects": []  # Une liste d'effets
	}
	for effect: AbstractEffect in effects:
		unitData["effects"].append(effect.registerEffect())
	return unitData
	
static func recoverUnit(data: Dictionary, player: AbstractPlayer) -> AbstractUnit :
	#Create a unit with all elements associated, need to add some things !!! like playerAssociated
	if UnitDb.UNITS.has(data.className):
		#Pas faisable car pas même nbr de param + inutile
		#var unit = UnitDb.UNITS[data.className].new(data.id, player, data.hpBase, data.powerBase, data.atkPerTurnBase, data.range, data.speedBase, data.drBase, data.mrBase, data.potential, data.wisdomBase)
		var unit = AbstractUnit.new(data.id, data.imgPath, player, data.grade, data.hpBase, data.powerBase, data.damageType, data.atkPerTurnBase, data.range, data.speedBase, data.drBase, data.mrBase, data.potential, data.wisdomBase)
		unit.initStats(data.uid, data.hpMax, data.hpActual, data.hpTemp, data.power, data.speed, data.speedRemaining, data.atkPerTurn, data.atkRemaining, data.dr, data.mr, data.wisdom, data.level, data.xp)
		unit.tile = data.tile
		for tag: int in data.tags:
			unit.tags.append(tag)
		
		for movementType: int in data.movementTypes:
			unit.movementTypes.append(data.movementTypes)
		unit.actualMovementTypes = data.actualMovementTypes
		unit.isDead = data.isDead
		for effectData in data.effects:
			unit.effects.append(AbstractEffect.recoverEffect(effectData, unit))
		return unit
	else :
		push_error("UNIT CLASS NOT FIND")
		return null#Maybe create a unit via ?
	
	
