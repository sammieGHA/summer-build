package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

import animate.FlxAnimate;

using StringTools;

class Boyfriend extends Character
{
	public var stunned:Bool = false;

	public function new(x:Float, y:Float) {
		super(x, y, 'bf', false, 'assets/images/characters/bf');

		anim.addBySymbol('idle', 'idle', 24, false);
		anim.addBySymbol('singLEFT', 'left', 24, false);
		anim.addBySymbol('singDOWN', 'down', 24, false);
		anim.addBySymbol('singUP', 'up', 24, false);
		anim.addBySymbol('singRIGHT', 'right', 24, false);

		anim.addBySymbol('singLEFTmiss', 'left', 24, false);
		anim.addBySymbol('singDOWNmiss', 'down', 24, false);
		anim.addBySymbol('singUPmiss', 'up', 24, false);
		anim.addBySymbol('singRIGHTmiss', 'right', 24, false);

		playAnim('idle');
		healthColor = 0xFF639bff;

		singDuration = 12;
		icon = 'bf';
	}

	override function update(elapsed:Float) {
		if (anim.curAnim != null) {
			if (anim.curAnim.name.endsWith('miss') && anim.curAnim.finished && !debugMode)
				playAnim('idle', true, false, 10);
		}

		super.update(elapsed);
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
		if (!anim.exists(AnimName))
			return;

		anim.play(AnimName, Force, Reversed, Frame);

		holdTimer = 0;

		var daOffset = animOffsets.get(AnimName);

		if (daOffset != null)
			offset.set(daOffset[0], daOffset[1]);
	}
}
