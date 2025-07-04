extends Node
class_name AbstractUnit
#Represent a unit
static var _uid_counter := 0
var id: String	#Id of the unit, serve to know the id of the unit
var uid: String	#Identifiant unique créer lorsqu'on place l'unité
var imgPath: String
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
var tags: Array[Tags.tags]
var tile: String	#Keep the name of the tile where is the unit
var isDead: bool	#Allow us to keep track of units killed

func _init(id: String, imgPath: String, playerAssociated: AbstractPlayer, hpBase: int, powerBase:int, damageType: DamageTypes.DamageTypes, atkPerTurnBase: int, speedBase: int, drBase: int, mrBase: int, potential: int, wisdomBase: int, idDead: bool = false):
	self.id = id
	_uid_counter += 1
	self.uid = str(randi() % 100000).pad_zeros(6) + str(Time.get_unix_time_from_system()) + str(_uid_counter)
	self.player = playerAssociated
	self.team = playerAssociated.team
	self.hpActual = hpBase
	self.hpMax = hpBase
	self.hpBase = hpBase
	self.hpTemp = 0
	self.power = powerBase
	self.powerBase = powerBase
	self.atkPerTurn = atkPerTurnBase
	self.atkRemaining = atkPerTurnBase
	self.atkPerTurnBase = atkPerTurnBase
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
func onPlacement(tile: String) -> void:
	self.tile = tile
	GameManager.whenUnitPlace(self)
	for effect: AbstractEffect in effects:
		effect.onPlacement(tile)

func onCardPlay(player: AbstractPlayer) -> void:
	for effect: AbstractEffect in effects:
		effect.onCardPlay(player)

func onUnitPlace(unit: AbstractUnit) -> void:
	for effect: AbstractEffect in effects:
		effect.onUnitPlace(unit)

#Tile is the actual tile after the movement
func onMovement(tile: String) -> void:
	self.tile = tile
	for effect: AbstractEffect in effects:
		effect.onMovement()

func onItemUsed(item: AbstractItem, player: AbstractPlayer) -> void:
	for effect: AbstractEffect in effects:
		effect.onItemUsed(item, player)

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
func onDamageDealed(unit: AbstractUnit, damageType: DamageTypes.DamageTypes) -> int :
	var damage: int = power
	for effect: AbstractEffect in effects:
		damage = effect.onDamageDealed(unit, damage, damageType)
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
	for effect: AbstractEffect in effects:
		effect.onKill(unitKilled)

func onDeath(unit: AbstractUnit = null) -> void:
	for effect: AbstractEffect in effects:
		effect.onDeath(unit)
	isDead = true	#You're not supposed to be able to survive once you're in this function

func onLevelUp(level: int) -> void :
	for effect: AbstractEffect in effects:
		effect.onLevelUp(level)

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if(turnColor == player.team):
		speedRemaining = speed
		atkRemaining = atkPerTurn
	for effect: AbstractEffect in effects:
		effect.onStartOfTurn(turnNumber, turnColor)


func registerUnit() -> JSON :
	var unitData := {
		"id": self.id,
		"uid": self.uid,
		"className": self.get_class(), # ou un champ "className" si tu le stockes explicitement
		"player_id": self.player.id,
		"hpBase": self.hpBase,
		"hpMax": self.hpMax,
		"hpActual": self.hpActual,
		"hpTemp": self.hpTemp,
		"powerBase": self.powerBase,
		"power": self.power,
		"atkPerTurnBase": self.atkPerTurn,
		"atkRemaining": self.atkRemaining,
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
		"tile": self.tile,
		"effects": []  # Une liste d'effets
	}
	for effect: AbstractEffect in effects:
		unitData["effects"].append(effect.registerEffect())
	var json = JSON.new()
	json = json.stringify(unitData)
	return json.data
	
static func recoverUnit(unitJson: JSON, player: AbstractPlayer) -> AbstractUnit :
	var data : Dictionary = unitJson.data
	#Create a unit with all elements associated, need to add some things !!! like playerAssociated
	if UnitDb.UNITS.has(data.className):
		var unit = UnitDb.UNITS[data.className].new(data.id, player, data.hpBase, data.powerBase, data.atkPerTurnBase, data.speedBase, data.drBase, data.mrBase, data.potential, data.wisdomBase)
		unit.initStats(data.uid, data.hpMax, data.hpActual, data.hpTemp, data.power, data.speed, data.speedRemaining, data.atkPerTurn, data.atkRemaining, data.dr, data.mr, data.wisdom, data.level, data.xp)
		unit.tile = data.tile
		unit.tags = data.tags
		for effectJson in data.effects:
			unit.effects.append(AbstractEffect.recoverEffect(effectJson, unit))
		return unit
	else :
		push_error("UNIT CLASS NOT FIND")
		return null#Maybe create a unit via ?
	
	
