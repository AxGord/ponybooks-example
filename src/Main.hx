import pony.net.http.SimpleWeb;
import pony.db.mysql.Config;
import haxe.Json;
import pony.fs.File;

class Main {

	static function main():Void {
		new SimpleWeb(pony.magic.Classes.dir('', 'models'), 'config.json');
	}
	
}