class_name TurnManager
#Manage all end of turn actions and to decide which team have to play

static var turn : int = 0 #Actual turn number
static var teams : Array[TeamsColor.TeamsColor] = []	#we stock all the color teams

static func addTeam(teamColor: TeamsColor.TeamsColor) -> void:
	teams.append(teamColor)

#param teams contains all TeamsColor from players
static func createTeams(teamsColor: Dictionary) -> void :
	for team: TeamsColor.TeamsColor in teamsColor:
		teams.append(team)

static func nextTurn() -> void:
	var nextTurn = teams[(turn+1) % teams.size()]
	turn += 1
	#Appel de toutes les unités pour appliquer les effets en envoyant le tour actuel et le tour à venir
	for unit : AbstractUnit in GameManager.getAllUnits() :
		unit.onStartOfTurn(turn, nextTurn)
	#Animation du bouton et actualisation de l'interface

static func actualTurn() -> TeamsColor.TeamsColor :
	return teams[turn % teams.size()]

static func recoverTurnManager() -> void :
	1
