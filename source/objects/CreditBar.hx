package objects;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import openfl.Assets;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

class CreditBar extends FlxSpriteGroup {
    var bg:FlxSprite;
    var displayText:FlxText;

    public function new(song:String) {
        super();

        var path = Paths.data('${song.toLowerCase()}/credits', '.txt');
        if (!Assets.exists(path)) return;
        var text = Util.splitTextFile(path);

		bg = new FlxSprite(-400, 0).makeGraphic(426, FlxG.height, FlxColor.BLACK);
        bg.alpha = .6;
        add(bg);

        displayText = new FlxText(-400, 35, bg.width, text.join('\n'));
        displayText.setFormat(Paths.fonts('comic'), 36);
        displayText.alignment = CENTER;
        add(displayText);

        for (asset in [bg, displayText]) {
            FlxTween.tween(asset, { x: 0 }, 1, { ease: FlxEase.elasticOut });
        }
    }

    public function leave() {
        if (bg == null) return;

        for (asset in [bg, displayText]) {
            FlxTween.tween(asset, { x: -400 }, 1, { ease: FlxEase.elasticIn, onComplete: _ -> {
                asset.destroy();
            }});
        }
    }
}