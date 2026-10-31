package states;

import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import openfl.Assets;
import states.CategoryState.DifficultyIcon;
import flixel.FlxSprite;

class StoryMenu extends MusicBeatState {
    public function new() super();

    var curSelected:Int = 0;

    var background:FlxSprite;
    var portraits:Array<FlxSprite> = [];
    var diffIcon:DifficultyIcon;
    var arrowLeft:FlxSprite;
    var arrowRight:FlxSprite;

    var camTarget:FlxObject;
    var camGame:FlxCamera;

    var songs:Array<String> = [
        'disruption',
        'diability',
        'applecore',
        'wireframe',
        'deformation',
        'fresh-and-toasted',
        'algebra',
        'ferocious',
        'nice'
    ];

    override function create() {
        camGame = FlxG.camera;
        camTarget = new FlxObject();
        add(camTarget);

        camGame.follow(camTarget, LOCKON, .2);

        for (i => song in songs) {
            var path = Paths.images('storyMenu/$song');
            if (!Assets.exists(path))
                path = Paths.images('storyMenu/rocket');

            var p = new FlxSprite().loadGraphic(path);
            p.scale.set(1.5, 1.5);
            p.updateHitbox();
            p.screenCenter();
            var spacing = i * (p.width + 200);
			p.x += spacing;
			portraits.push(p);
            add(p);

            var logo = new FlxSprite().loadGraphic(Paths.images('storyMenu/logos/$song'));
            logo.scale.set(.5, .5);
            logo.updateHitbox();
            logo.screenCenter();
            logo.y = p.y - 160;
			logo.x += spacing;
            add(logo);
        }

        move();
    
        super.create();
    }

    override function update(dt:Float) {
        super.update(dt);

        if (controls.BACK)
            FlxG.switchState(() -> new states.MenuSelect());

        if (controls.LEFT_P)
            move(-1);
        if (controls.RIGHT_P)
            move(1);

        if (controls.ACCEPT) {
            try {
                PlayState.SONG = Song.loadFromJson(songs[curSelected]);
                FlxG.switchState(() -> new PlayState());
            } catch (e:Dynamic) {
                trace(e);
            }
        }
    }

    function move(dir:Int = 0) {
		if (dir != 0) {
			FlxG.sound.play('assets/sounds/scrollMenu.ogg');

            curSelected += dir;
			curSelected = Std.int(FlxMath.bound(curSelected, 0, portraits.length - 1));
		}

		var portrait = portraits[curSelected];

		camTarget.setPosition(portrait.x + portrait.width / 2, portrait.y + portrait.height / 2);
    }
}