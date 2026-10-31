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
		super(x, y, 'assets/images/characters/bf/bf');

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
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim == null) return;

		if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
		{
			playAnim('idle', true, false, 10);
		}

		if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
		{
			playAnim('deathLoop');
		}

		super.update(elapsed);
	}
}
