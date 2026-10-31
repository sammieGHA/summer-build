package states;

import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Json;
import openfl.Assets;
import objects.MenuBackground;

using StringTools;

class CategoryState extends MusicBeatState {
    final categories:Array<String> = ['extras', 'oc', 'iykyk', 'joke', 'secret'];
    final songs:Array<Array<String>> = [
        ['sugar-rush', 'the-big-dingle', 'jeeeeez', 'chippy', 'origin', 'alternate', '3d-bandu-song', 'shucks'],
        ['suave', 'nuts', 'police', 'rocky-road', 'enforcers', 'cambi-deluxe'],
        ['curveball', 'timelapse', 'og', 'filtered', 'gacha', 'fanimated', 'ringtone', 'creation'],
        ['awesome', 'sped', 'vs-the-poop', 'screwedathon', 'roxanne-signing-unfairness', 'retro', 'lazelmaybe-had-a-verity', 'slices', 'bigger-leak'],
        ['ticking', 'irreversible-action', 'aug', 'froicus', 'flipper', 'super-nostalgia-blast', 'bigger', 'ripple', 'them-apples']
    ];

    var categoryItems:Array<Item> = [];

    var selectedCategory:Int = 0;
    var selectedSong:Int = 0;

    var categoryCamera:FlxCamera;
    var freeplayCamera:FlxCamera;
    var cameraTarget:FlxObject;

    var background:MenuBackground;

    var grpSongs:FlxTypedGroup<Alphabet>;
	var difficultyIcon:DifficultyIcon;

    var categoryText:FlxText;

    var bingSound:FlxSound;
    static var bingPlayed:Bool = false;

	var colorTween:FlxTween;

    public function new() {
        super();
    }

    override function create() {
        categoryCamera = new FlxCamera();
        categoryCamera.bgColor.alpha = 0;
        freeplayCamera = new FlxCamera();
        freeplayCamera.bgColor.alpha = 0;

        FlxG.cameras.reset(freeplayCamera);
        FlxG.cameras.add(categoryCamera, false);

		cameraTarget = new FlxObject(0, FlxG.height / 2, 1, 1);
		categoryCamera.follow(cameraTarget, LOCKON, .65);
        categoryCamera.snapToTarget();

		background = new MenuBackground();
        background.scrollFactor.set();
        add(background);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
        
        var whiteBorder:FlxSprite;
        whiteBorder = new FlxSprite().makeGraphic(FlxG.width, 150);
        whiteBorder.alpha = .6;
        whiteBorder.cameras = [categoryCamera];
        whiteBorder.scrollFactor.set();
        add(whiteBorder);

		var borderOutline = new FlxSprite(0, whiteBorder.height).makeGraphic(FlxG.width, 18, FlxColor.BLACK);
		borderOutline.cameras = [categoryCamera];
		borderOutline.scrollFactor.set();
        borderOutline.alpha = .6;
		add(borderOutline);

		for (i => key in categories) {
			var item = new Item(key);
			item.screenCenter(X);
			item.x += i + (i * 256);
			item.cameras = [categoryCamera];
			categoryItems.push(item);
			add(item);
		}

        var arrow = new FlxSprite(0, 160).loadGraphic(Paths.images('categories/arrow'));
		arrow.flipY = true;
		arrow.scale.set(1.7, 1.7);
		arrow.updateHitbox();
        arrow.screenCenter(X);
        arrow.scrollFactor.set();
        arrow.cameras = [categoryCamera];
        add(arrow);

        categoryText = new FlxText(0, 170, 0, '');
        categoryText.setFormat('assets/fonts/comic.ttf', 36, FlxColor.BLACK, RIGHT, OUTLINE, FlxColor.WHITE);
        categoryText.scrollFactor.set();
        add(categoryText);

		var bottomLayer = new FlxSprite().makeGraphic(FlxG.width, 40, FlxColor.BLACK);
		bottomLayer.y = FlxG.height - bottomLayer.height;
		bottomLayer.alpha = .6;
		add(bottomLayer);

        var bottomText:FlxText = new FlxText(15, 0, 0, 'Press B to Bing');
        bottomText.setFormat(Paths.fonts('comic'), 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        bottomText.y = bottomLayer.y + (bottomLayer.height - bottomText.height) / 2;
        add(bottomText);

		difficultyIcon = new DifficultyIcon();
		add(difficultyIcon);

        moveLR(0);

		bingSound = new FlxSound();
		bingSound.load('assets/sounds/bing.ogg');
        bingSound.volume = 1;
        bingSound.onComplete = () -> {
            Sys.exit(0);
        }

		super.create();
    }

    override function update(dt:Float) {
        super.update(dt);

        if (controls.BACK)
            FlxG.switchState(() -> new states.MenuSelect());

        if (controls.LEFT_P)
            moveLR(-1);
        else if (controls.RIGHT_P)
            moveLR(1);
		if (controls.UP_P)
			moveUD(-1);
		else if (controls.DOWN_P)
			moveUD(1);

        if (controls.ACCEPT) {
            try {
                PlayState.SONG = Song.loadFromJson(songs[selectedCategory][selectedSong]);
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
                FlxG.switchState(() -> new PlayState());
            } catch (e:Dynamic) {
                trace(e);
            }
        }

        if (FlxG.keys.justPressed.B && !bingPlayed) {
            bingPlayed = true;
            bingSound.play();
        }
    }

	function moveLR(dir:Int = 0) {
        if (dir != 0) 
            FlxG.sound.play('assets/sounds/scrollMenu.ogg');

		var oldCategory = selectedCategory;

		selectedCategory += dir;
		selectedCategory = Std.int(FlxMath.bound(selectedCategory, 0, categoryItems.length - 1));

		for (i => item in categoryItems)
			item.alpha = (i == selectedCategory) ? 1 : .6;

		cameraTarget.x = categoryItems[selectedCategory].getMidpoint().x;

        categoryText.text = categories[selectedCategory];
		categoryText.x = FlxG.width - categoryText.width - 5;

		if (selectedCategory != oldCategory || dir == 0)
			loadSongs();
	}
    
	function moveUD(dir:Int = 0) {
		if (dir != 0)
			FlxG.sound.play('assets/sounds/scrollMenu.ogg');

		selectedSong += dir;
		var len = songs[selectedCategory].length;
		if (selectedSong < 0)
			selectedSong = len - 1;
		if (selectedSong >= len)
			selectedSong = 0;

		for (i => item in grpSongs.members) {
			item.targetY = i - selectedSong;
			item.alpha = (item.targetY == 0) ? 1 : .6;
		}

		var meta = getMeta(songs[selectedCategory][selectedSong]);
		difficultyIcon.setDifficulty(Std.string(meta.difficulty).toLowerCase());

		if (colorTween != null)
			colorTween.cancel();
		colorTween = FlxTween.color(background, .1, background.color, getColor(meta));
	}

	function loadSongs() {
		for (obj in grpSongs.members)
			obj.destroy();
		grpSongs.clear();

		for (i => song in songs[selectedCategory]) {
			var display = song.replace('-', ' ');
			var text = new Alphabet(0, (120 * i) + 30, display, true, false);
			text.isMenuItem = true;
			text.targetY = i;
			grpSongs.add(text);
		}

		selectedSong = 0;
		moveUD(0);
	}

	function getMeta(song:String):Dynamic {
		var path = 'assets/data/$song/meta.json';
		if (!Assets.exists(path))
			return {};

		try {
			return Json.parse(Assets.getText(path));
		} catch (e) {}

		return {};
	}

	function getColor(meta:Dynamic):FlxColor {
		if (meta.color == null)
			return FlxColor.WHITE;

		var parsed = FlxColor.fromString(Std.string(meta.color));
		return parsed != null ? parsed : FlxColor.WHITE;
	}
}

class Item extends FlxSprite {
    public function new(category:String) {
        super();

		loadGraphic(Paths.images('categories/$category'));
        scale.set(.5, .5);
        updateHitbox();

        y = 10;
    }
}

class DifficultyIcon extends FlxSprite {
	static final known:Array<String> = ['easy', 'normal', 'hard', 'extreme', 'none'];

	var current:String = '';

	public function new() {
		super();
		scrollFactor.set();
		setDifficulty('none');
	}

	public function setDifficulty(diff:String) {
		if (!known.contains(diff))
			diff = 'none';
		if (diff == current)
			return;

		current = diff;
		loadGraphic(Paths.images('diff/$diff'));
		x = FlxG.width - width - 20;
		y = FlxG.height - height - 20;
	}
}