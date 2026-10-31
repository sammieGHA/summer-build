package objects;

import flixel.FlxSprite;
import flixel.FlxG;
class MenuBackground extends FlxSprite {
    public function new() {
        super();

        loadGraphic(Paths.images('menuBG/${FlxG.random.int(0, 5)}'));
        setGraphicSize(FlxG.width, FlxG.height);
    }
}