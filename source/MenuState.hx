package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState {
	override public function create()
	{
		super.create();

		#if !mobile
		FlxG.mouse.useSystemCursor = true;
		#end

		bgColor = FlxColor.GRAY;

		var title = new FlxText(0, 0, 0, "Catch!", 40, false);
		title.setFormat(AssetPaths.prstartk__ttf, 20, FlxColor.BLACK, CENTER);
		title.screenCenter();
		add(title);

		var playButton = new FlxButton(0, title.y + title.height, "Play!", function() {
			FlxG.switchState(new PlayState());
		});
		playButton.x = (FlxG.width - playButton.width) / 2;
		playButton.label.setFormat(AssetPaths.prstartk__ttf, 5, FlxColor.BLACK, CENTER);
		add(playButton);

		var creditsText = new FlxText(0, 0, 0, "Credits:\nMusic:http://soundimage.org/\noof:Roblox\n\nBackground:https://vnitti.itch.io/glacial-mountains-parallax-background\nUI:https://kenney.nl/assets/pixel-ui-pack", 10, false);
		creditsText.setFormat(AssetPaths.prstartk__ttf, 5, FlxColor.BLACK, LEFT);
		add(creditsText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}