package util;

@:publicFields
final class Paths {
    static inline function images(k:String, ?ext:String = '.png'):String
        return 'assets/images/$k$ext';

	static inline function music(k:String, ?ext:String = '.ogg'):String
		return 'assets/music/$k$ext';

	static inline function data(k:String, ?ext:String = '.json'):String
		return 'assets/data/$k$ext';

	static inline function fonts(k:String, ?ext:String = '.ttf'):String
		return 'assets/fonts/$k$ext';
}