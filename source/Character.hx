package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import animate.FlxAnimate;

using StringTools;

class Character extends FlxAnimate
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var healthColor:FlxColor = FlxColor.WHITE;
	public var holdTimer:Float = 0;
	public var singDuration:Float = 4;
	public var icon:String;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false, ?atlasPath:Null<String> = null)
	{
		animOffsets = new Map<String, Array<Dynamic>>();
		super(x, y, atlasPath);

		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = false;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = FlxAtlasFrames.fromSparrow(AssetPaths.GF_assets__png, AssetPaths.GF_assets__xml);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);

				addOffset('scared');

				playAnim('danceRight');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = FlxAtlasFrames.fromSparrow(AssetPaths.DADDY_DEAREST__png, AssetPaths.DADDY_DEAREST__xml);
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				playAnim('idle');

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				healthColor = 0xFF76428a;
			case 'sugar-bandu':
				tex = FlxAtlasFrames.fromSparrow(Paths.images('characters/DIDY DESPAIR'), Paths.images('characters/DIDY DESPAIR', '.xml'));
				frames = tex;
				animation.addByPrefix('idle', 'idle instance 10', 24);
				animation.addByPrefix('singUP', 'up instance 10', 24);
				animation.addByPrefix('singRIGHT', 'right instance 10', 24);
				animation.addByPrefix('singDOWN', 'down instance 10', 24);
				animation.addByPrefix('singLEFT', 'left instance 10', 24);
				playAnim('idle');

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				healthColor = 0xFF46F501;
				icon = 'sugar';
		}
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		switch (curCharacter)
		{
			case 'bf':
			case 'gf':
				danced = !danced;

				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');
			default:
				playAnim('idle');
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (!animation.exists(AnimName))
			return;

		animation.play(AnimName, Force, Reversed, Frame);
		holdTimer = 0;

		var daOffset = animOffsets.get(AnimName);

		if (daOffset != null)
			offset.set(daOffset[0], daOffset[1]);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	override function update(elapsed:Float) {
		if (!debugMode && !isPlayer && animation.curAnim != null && animation.curAnim.name.startsWith('sing')) {
			holdTimer += elapsed;

			if (holdTimer >= Conductor.stepCrochet * singDuration * 0.001) {
				dance();
				holdTimer = 0;
			}
		}

		super.update(elapsed);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
