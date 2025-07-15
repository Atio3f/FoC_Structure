class_name AbstractPlayer


var playerName: String 
var team: TeamsColor.TeamsColor #Team Color
var units: Array[AbstractUnit] = []
var orbs: int
var maxOrbs: int
const ORBS_BASE: int = 2
const MAX_ORBS_BASE: int = 5
var hand: PlayerHand

func _init(team: TeamsColor.TeamsColor, name: String):
	self.playerName = name
	self.team = team
	GameManager.players.append(self)
	orbs = ORBS_BASE
	maxOrbs = MAX_ORBS_BASE


func getUnits() -> Array[AbstractUnit]:
	return units

func getUnitsByTag(tag: Tags.tags) -> Array[AbstractUnit]:
	var _units : Array[AbstractUnit] = []
	for unit in units:
		if(unit.tags.has(tag) && !unit.isDead):
			_units.append(unit)
	return _units

func getCards() -> Array[String] :
	return hand.cards

func useCard(idCard: String) -> void :
	hand.useCard(idCard)
func registerPlayer() -> Dictionary :
	var playerData := {
		"playerName": self.playerName,
		"team": self.team,
		"orbs": self.orbs,
		"maxOrbs": self.maxOrbs,
		"units": []  # Une liste d'unités
	}
	for unit: AbstractUnit in units:
		playerData["units"].append(unit.registerUnit())
	return playerData


static func recoverPlayer(data: Dictionary) -> AbstractPlayer :
	var player = AbstractPlayer.new(data.team, data.playerName)
	player.orbs = data.orbs
	player.maxOrbs = data.maxOrbs
	for unitData in data.units:
		player.units.append(AbstractUnit.recoverUnit(unitData, player))
	return player
