package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxSave;

class GameOverState extends FlxState
{
	var score:Int;

	public function new(score:Int)
	{
		super();

		this.score = score;
	}

	override public function create():Void
	{
		super.create();

		FlxG.sound.load(AssetPaths.gameOver__wav).play();

		bgColor = FlxColor.ORANGE;

		var text:String;
		var save = new FlxSave();
		save.bind("1");
		if (save.data.highScore != null)
		{
			if (score >= save.data.highScore)
			{
				text = "You beat your high score with " + score;
				save.data.highScore = score;
				save.flush();
			}
			else
			{
				text = "You got " + score;
			}
		}
		else
		{
			text = "You got " + score;
			save.data.highScore = score;
			save.flush();
		}
		text += "\nAgain?";

		// For some reason string interpolation wasn't working...?
		var gameOverText = new FlxText(0, 0, 0, text, 40, false);
		gameOverText.setFormat(AssetPaths.prstartk__ttf, 20, FlxColor.BLACK, CENTER);
		gameOverText.screenCenter();
		add(gameOverText);

		var againButton = new FlxButton(0, gameOverText.y + gameOverText.height, "Yes, I'm cool!", function() {
			FlxG.switchState(new PlayState());
		});
		againButton.x = (FlxG.width - 2 * againButton.width) / 2;
		againButton.label.setFormat(AssetPaths.prstartk__ttf, 5, FlxColor.BLACK, CENTER);
		add(againButton);

		var noButton = new FlxButton(FlxG.width / 2, gameOverText.y + gameOverText.height, "No, I'm boring!", function() {
			gameOverText.text = "Are you sure?";
			gameOverText.size = 80;
			gameOverText.color = FlxColor.RED;
			gameOverText.font = AssetPaths.BLOODY__TTF;
			gameOverText.screenCenter();
			FlxG.camera.shake();
		});
		noButton.x = (FlxG.width + noButton.width) / 2;
		noButton.label.setFormat(AssetPaths.prstartk__ttf, 5, FlxColor.BLACK, CENTER);
		add(noButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}