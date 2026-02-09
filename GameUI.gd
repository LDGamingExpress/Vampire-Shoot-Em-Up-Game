extends Control
var score = 0

func add_score(scoreToAdd : int):
	score += scoreToAdd
	$ScorePanel/Score.text = "Score: " + str(score)
	
	if score > Globals.HighScore:
		Globals.HighScore = score
		$ScorePanel/HighScore.text = "Score: " + str(score)
