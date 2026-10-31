package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import states.MainMenu.Button;

class MenuSelect extends MusicBeatState {
    public function new() {
        super();
    }

    override function create() {
        FlxG.mouse.visible = true;

        var bg = new FlxBackdrop(Paths.images('mainMenu/bg'));
		bg.scale.set(.7, .7);
		bg.updateHitbox();
		bg.velocity.set(-100, -100);
        bg.antialiasing = true;
        add(bg);

        var splash = new FlxSprite(0, 0, Paths.images('mainMenu/splash'));
        add(splash);

        var storyMenu = new Button(0, 0, Paths.images('mainMenu/story'), () -> {
            FlxG.switchState(() -> new states.StoryMenu());
        });

        storyMenu.screenCenter();
        storyMenu.x -= 300;
        storyMenu.y -= 100;

		var freeMenu = new Button(0, 0, Paths.images('mainMenu/freeplay'), () -> {
			FlxG.switchState(() -> new states.CategoryState());
		});

		freeMenu.screenCenter();
		freeMenu.x += 300;
		freeMenu.y += 100;

        add(storyMenu);
        add(freeMenu);

        super.create();
    }

    override function update(dt:Float) {
        super.update(dt);

        if (controls.BACK)
            FlxG.switchState(() -> new states.MainMenu());
    }
}