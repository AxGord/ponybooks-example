package models;

import pony.Tools;
import pony.fs.File;
import pony.fs.Dir;
import pony.tests.Errors;
import pony.net.http.modules.mmodels.ModelConnect;
import pony.db.DBV;
import pony.net.http.modules.mmodels.fields.FImg;
import pony.net.http.modules.mmodels.fields.FText;
import pony.net.http.modules.mmodels.fields.FDate;
import pony.net.http.modules.mmodels.fields.FString;
import pony.net.http.modules.mmodels.Model;

@:keep @:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class Books extends Model {

	static var fields = {
		title: new FString(),
		date: new FDate(),
		author: new FString(),
		description: new FText(),
		image: new FImg()
	};

	@:async override public function prepare():Bool {
		var err, _, remote = @await db.mysql.query('SELECT * FROM $name LIMIT 0');
		if (err) {
			var r:Bool = @await super.prepare();
			if (r) for (i in 1...6)
				@await db.insert([
					'title' => ('title$i':DBV),
					'date' => (Std.int(Sys.time()):DBV),
					'author' => ('author$i':DBV),
					'description' => ('description$i':DBV),
					'image' => ('null.png':DBV)
				]);
			return r;
		}
		return true;
	}

}

@:keep @:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class BooksConnect extends ModelConnect {

	@:async function many() {
		// var db = db.limit(3);
		if (cpq.query.length == 2) {
			switch (cpq.query[1]) {
				case 'asc':
					return @await db.asc(cpq.query[0]).get();
				case 'desc':
					return @await db.desc(cpq.query[0]).get();
				case _:
					return @await db.get();
			}
		} else {
			return @await db.get();
		}
	}

	@:path(['editbook'])
	@:async function single(id:String) {
		return @await db.where(id == $id).first();
	}
	
	@:async function insert(title:String, author:String, description:String, image:String):Bool {
		if (image != null) {
			var img:File = image.split(':')[1];
			var dir:Dir = cpq.usercontent;
			var count:Int = dir.content().length;
			var imgName:String = Std.string(count) + '.' + img.ext;
			img.copyToDir(dir, imgName);
			return @await db.insert([
				'title' => (title:DBV),
				'date' => (Std.int(Sys.time()):DBV),
				'author' => (author:DBV),
				'description' => (description:DBV),
				'image' => (imgName:DBV)
			]);
		} else {
			return @await db.insert([
				'title' => (title:DBV),
				'date' => (Std.int(Sys.time()):DBV),
				'author' => (author:DBV),
				'description' => (description:DBV),
				'image' => ('null.png':DBV)
			]);
		}
	}

	@:async function update(id:String, title:String, author:String, description:String, image:String):Bool {
		if (image != null && image != '') {
			var img:File = image.split(':')[1];
			var dir:Dir = cpq.usercontent;
			var count:Int = dir.content().length;
			var imgName:String = Std.string(count) + '.' + img.ext;
			img.copyToDir(dir, imgName);
			return @await db.where(id == $id).update([
				'title' => (title:DBV),
				'date' => (Std.int(Sys.time()):DBV),
				'author' => (author:DBV),
				'description' => (description:DBV),
				'image' => (imgName:DBV)
			]);
		} else {
			return @await db.where(id == $id).update([
				'title' => (title:DBV),
				'date' => (Std.int(Sys.time()):DBV),
				'author' => (author:DBV),
				'description' => (description:DBV)
			]);
		}
	}
	
	function insertValidate(title:String, author:String, description:String, image:String):Errors {
		var e = new Errors();

		e.arg = 'title';
		e.test(title.length > 32, 'Is long');
		e.arg = 'author';
		e.test(author.length > 32, 'Is long');
		
		e.arg = 'description';
		e.test(description == '', 'Empty');
		e.test(description.length < 5, 'Is short');
		e.test(description.length > 500, 'Is long');

		return e;
	}

	function updateValidate(id:String, title:String, author:String, description:String, image:String):Errors {
		return insertValidate(title, author, description, image);
	}

}