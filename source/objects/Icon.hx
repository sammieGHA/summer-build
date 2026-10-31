package objects;

import flixel.FlxSprite;
import openfl.Assets;

class Icon extends FlxSprite {
    public var char:String = '';
    public var isPlayer:Bool;

    public function new(char:String = 'face', isPlayer:Bool = false) {
        super();
        this.isPlayer = isPlayer;
        scrollFactor.set();
        setChar(char);
    }

    public function setChar(char:String) {
        if (this.char == char) return;
        this.char = char;

        var path = Paths.images('icons/$char');
        if (!Assets.exists(path))
            path = Paths.images('icons/face');

        loadGraphic(path, true, 150, 150);
        animation.add('default', [0], 0, false);
        animation.add('losing', [1], 0, false);
        animation.play('default');

        flipX = isPlayer;
    }

    public function setLosing(losing:Bool) {
        animation.play(losing ? 'losing' : 'default');
    }
}