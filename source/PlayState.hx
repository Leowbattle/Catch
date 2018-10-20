package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
import flixel.system.FlxSound;

class PlayState extends FlxState
{
	var random:FlxRandom;

	var player:FlxSprite;
	var playerSpeed:Int = 12;

	var lives:Int = 5;
	var livesText:FlxText;

	var score:Int = 0;
	var scoreText:FlxText;

	var items:FlxSpriteGroup;
	var fallSpeed:Int = 12;
	var itemSpawner:FlxTimer;

	var itemSound:FlxSound;
	var lifeLostSound:FlxSound;

	override public function create():Void
	{
		super.create();

		FlxG.sound.playMusic(AssetPaths.Frantic_Gameplay__wav, 1, true);

		var bg = new FlxSprite();
		bg.loadGraphic(AssetPaths.glacial_mountains__png);
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		random = new FlxRandom();

		player = new FlxSprite();
		player.makeGraphic(100, 30, FlxColor.BLUE, true);
		player.x = (FlxG.width - player.width) / 2;
		player.y = FlxG.height - 50;
		player.moves = false;
		player.maxVelocity.x = playerSpeed;
		add(player);

		scoreText = new FlxText(0, 0, 0, "Score: 0", 20, false);
		scoreText.setFormat(AssetPaths.prstartk__ttf, 20, FlxColor.BLACK, LEFT);
		add(scoreText);
		livesText = new FlxText(0, scoreText.height, 0, "Lives: 5", 20, false);
		livesText.setFormat(AssetPaths.prstartk__ttf, 20, FlxColor.BLACK, LEFT);
		add(livesText);

		items = new FlxSpriteGroup();
		add(items);
		itemSpawner = new FlxTimer();
		itemSpawner.start(1, spawnItem, 0);

		itemSound = FlxG.sound.load(AssetPaths.item__wav);
		lifeLostSound = FlxG.sound.load(AssetPaths.lifeLost__wav);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		#if !mobile
		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			player.x -= playerSpeed;
		}
		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			player.x += playerSpeed;
		}
		#else
		for (touch in FlxG.touches.list)
		{
			if (touch.x < FlxG.width / 2)
			{
				player.x -= playerSpeed;
			}
			else
			{
				player.x += playerSpeed;
			}
		}
		#end
		FlxSpriteUtil.screenWrap(player, true, true, false, false);

		items.forEachAlive(function(item:FlxSprite) {
			if (!item.isOnScreen())
			{
				item.kill();
				livesText.text = "Lives: " + --lives;
				FlxG.camera.shake();
				if (lives <= 0)
				{
					FlxG.switchState(new GameOverState(score));
				}
				else
				{
					lifeLostSound.play();
				}
			}
			else if (FlxG.collide(item, player))
			{
				item.kill();
				scoreText.text = "Score: " + ++score;
				itemSound.play();
			}
		}, false);
	}

	function spawnItem(timer:FlxTimer):Void
	{
		// Difficulty scaling
		timer.time -= 0.05;
		if (timer.time < 0.5)
		{
			timer.time = 0.5;
		}

		var item = new FlxSprite();
		var colour = random.color();
		while (colour == FlxColor.TRANSPARENT)
		{
			colour = random.color();
		}
		colour.alpha = 255;
		item.makeGraphic(30, 30, colour, false);
		item.x = random.int(0, FlxG.width - cast(item.width));
		item.acceleration.y = 400;
		item.maxVelocity.y = 4000;
		item.angularVelocity = 90;
		items.add(item);
	}
}
