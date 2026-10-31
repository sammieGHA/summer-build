package util;

import openfl.Assets;

enum SongType {
    INST;
    VOICES;
}

final class Util {
    public static function getSongPath(song:String, type:SongType):String {
        song = song.toLowerCase();

		if (!Assets.exists(Paths.data('$song/Inst', '.ogg')))
            trace('Uh oh! Inst doesn\'t exist!');

		if (!Assets.exists(Paths.data('$song/Voices', '.ogg')))
			trace('Uh oh! Voices doesn\'t exist!');

        return type == INST ? Paths.data('$song/Inst', '.ogg') : Paths.data('$song/Voices', '.ogg');
    }

    public static function splitTextFile(path:String):Array<String> {
        var raw = Assets.getText(path);
        var txt = raw.split('\n');
		return txt;
    }
}