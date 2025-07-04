extends Node
class_name AbstractPlayer



var team: TeamsColor.TeamsColor #Team Color
var units: Array[AbstractUnit] = []

func _init(team: TeamsColor.TeamsColor):
	self.team = team
	GameManager.players.append(self)

func getUnits() -> Array[AbstractUnit]:
	return units

func getUnitsByTag(tag: Tags.tags) -> Array[AbstractUnit]:
	var _units : Array[AbstractUnit] = []
	for unit in units:
		if(unit.tags.has(tag)):
			_units.append(unit)
	return _units


func registerPlayer() -> JSON :
	var playerData := {
		"team": self.team,
		"units": []  # Une liste d'unités
	}
	for unit: AbstractUnit in units:
		playerData["units"].append(unit.registerEffect())
	var json = JSON.new()
	json = json.stringify(playerData)
	return json.data


static func recoverPlayer(playerJson: JSON) -> AbstractPlayer :
	var data : Dictionary = playerJson.data
	
	var player = AbstractPlayer.new(data.team)
	for unitJson in data.units:
		player.units.append(AbstractUnit.recoverUnit(unitJson, player))
	return player
