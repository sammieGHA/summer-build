package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.AntiAliasType;
import openfl.Lib;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState, 60, 60, true, false));
		addChild(new FPSCounter(10, 3));
	}
}

class FPSCounter extends TextField {
	var currentFPS:Int = 0;
	var frameCount:Int = 0;
	var elapsedTime:Float = 0;

	public function new(x:Float = 10, y:Float = 3) {
		super();

		this.x = x;
		this.y = y;

		defaultTextFormat = new TextFormat('Comic Sans MS', 24, 0xFFFFFF, true);

		text = "FPS: 0";
		selectable = false;
		mouseEnabled = false;
		antiAliasType = AntiAliasType.ADVANCED;

		width = 200;
		height = 50;

		Lib.current.stage.addEventListener(openfl.events.Event.ENTER_FRAME, updateFPS);
	}

	function updateFPS(_) {
		frameCount++;
		elapsedTime += Lib.getTimer() / 1000 - lastTime;
		lastTime = Lib.getTimer() / 1000;

		if (elapsedTime >= 1) {
			text = 'FPS: $frameCount';
			frameCount = 0;
			elapsedTime = 0;
		}
	}

	var lastTime:Float = Lib.getTimer() / 1000;
}