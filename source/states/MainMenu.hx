package states;

import flixel.text.FlxText;
import openfl.net.URLRequest;
import openfl.Lib;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class MainMenu extends MusicBeatState {
    var art:FlxSprite;

    public function new() {
        super();
    }

    override function create() {
        var bg = new objects.MenuBackground();
		bg.color = 0xffaaffaa;
        add(bg);
        FlxG.mouse.visible = true;

        var border = new FlxSprite(30, 0, Paths.images('mainMenu/border'));
        border.scale.set(.75, .75);
        border.updateHitbox();
        border.screenCenter(Y);
        add(border);

        var padding = 120;

        var play = new Button(border.x + 10, border.y + 10, Paths.images('mainMenu/play'), () -> {
            FlxG.switchState(() -> new MenuSelect());
        });

		var settings = new Button(border.x + 10, play.y + padding, Paths.images('mainMenu/settings'), () -> {
            FlxG.debugger.visible = true;
            FlxG.log.error('nah you thought');
        });

		var credits = new Button(border.x + 10, settings.y + padding, Paths.images('mainMenu/credits'), () -> {
            // uuuh
        });

		var discord = new Button(border.x + 10, credits.y + padding, Paths.images('mainMenu/discord'), () -> {
			Lib.getURL(new URLRequest('https://discord.gg/a5GfzBP8Vd'));
        });

		play.onHover = () -> setArt('play');
		settings.onHover = () -> setArt('settings');
		credits.onHover = () -> setArt('credits');
		discord.onHover = () -> setArt('discord');

        add(play);
        add(settings);
        add(credits);
        add(discord);

        art = new FlxSprite();
        setArt('play');
        add(art);

        var watermark = new FlxText(8, 0, 0, '1.5 Golden Apple Engine');
        watermark.setFormat(Paths.fonts('comic'), 24, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        watermark.y = FlxG.height - watermark.height - 8;
        add(watermark);

        super.create();
    }

    override function update(dt:Float) {
        super.update(dt);
        
        if (FlxG.keys.justPressed.SEVEN) {
            try {
				PlayState.SONG = Song.loadFromJson('tutorial');
				FlxG.switchState(() -> new ChartingState());
            } catch (e:Dynamic) {
                trace(e);
            }
        }
    }

	function setArt(name:String) {
        FlxG.sound.play('assets/sounds/scrollMenu.ogg');

		art.loadGraphic(Paths.images('mainMenu/art/$name'));
		art.screenCenter(Y);
		art.x = FlxG.width - art.width - 20;
	}
}

class Button extends FlxSprite {
    public var onClick:Void -> Void;
	public var onHover:Void->Void;

	var wasHovered:Bool = false;

    public function new(x:Float, y:Float, spr:String, onClick:Void -> Void) {
        super(x, y, spr);

        this.onClick = onClick;
        scale.set(.8, .8);
        updateHitbox ();
    }

	override function update(dt:Float) {
		super.update(dt);

		var hovered = FlxG.mouse.overlaps(this);

		if (hovered && !wasHovered && onHover != null)
			onHover();
		wasHovered = hovered;

		color = hovered ? 0xFFC9C9C9 : FlxColor.WHITE;

		if (hovered && FlxG.mouse.justPressed)
			onClick();
	}
}