package;

import openfl.Lib;

#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
#end

import display.ToastCore;
import display.Info;

import util.MacroUtil;

#if linux
import lime.graphics.Image;
#end

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

using StringTools;

class Main extends openfl.display.Sprite
{
	public static final gameVersion:String = '0.5.5'; // don't assign another value to this please

	public static var buildNum(default, never):Int = MacroUtil.get_build_num();
	public static var commitId(default, never):String = MacroUtil.get_commit_id();

	public static var toast:ToastCore;
	public static var fpsDisplay:Info;

	private var gameWidth:Int = 1280;
	private var gameHeight:Int = 720;
	private var zoom:Float = -1;

	public function new()
	{
		super();

		#if windows
		util.Windows.darkMode(true);
		#end

		final stageWidth:Int = Lib.current.stage.stageWidth;
		final stageHeight:Int = Lib.current.stage.stageHeight;
		
		if (zoom == -1)
		{
			final ratioX:Float = stageWidth / gameWidth;
			final ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		addChild(new flixel.FlxGame(gameWidth, gameHeight, states.BootState, #if (flixel < "5.0.0") zoom, #end 60, 60, true, false));

		fpsDisplay = new Info();
		addChild(fpsDisplay);

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (e) ->
		{
			var errMsg:String = "";
			var path:String;
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var dateNow:String = Date.now().toString();

			dateNow = dateNow.replace(" ", "_");
			dateNow = dateNow.replace(":", "'");

			path = "./crash/" + "VisionSphere_" + dateNow + ".txt";

			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case FilePos(s, file, line, column):
						errMsg += file + " (line " + line + ")\n";
					default:
						Sys.println(stackItem);
				}
			}

			errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/Joalor64GH/VisionSphere\n\n> Crash Handler written by: sqirra-rng";

			if (!FileSystem.exists("./crash/"))
				FileSystem.createDirectory("./crash/");

			File.saveContent(path, errMsg + "\n");

			Sys.println(errMsg);
			Sys.println("Crash dump saved in " + Path.normalize(path));

			#if windows
			util.Windows.messageBox("Error!", errMsg, MSG_ERROR);
			#else
			Application.current.window.alert(errMsg, "Error!");
			#end
		
			Sys.exit(0);
		});
		#end

		#if windows
		Lib.current.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, (evt:openfl.events.KeyboardEvent) ->
		{
			if (evt.keyCode == openfl.ui.Keyboard.F2)
			{
				var sp = Lib.current.stage;
				var position = new openfl.geom.Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);

				var image:flash.display.BitmapData = new flash.display.BitmapData(Std.int(position.width), Std.int(position.height), false, 0xFEFEFE);
				image.draw(sp, true);

				if (!FileSystem.exists("./screenshots/"))
					FileSystem.createDirectory("./screenshots/");

				var bytes = image.encode(position, new openfl.display.PNGEncoderOptions());

				var curDate:String = Date.now().toString();

				curDate = StringTools.replace(curDate, " ", "_");
				curDate = StringTools.replace(curDate, ":", "'");

				File.saveBytes("screenshots/Screenshot-" + curDate + ".png", bytes);
			}
		});
		#end

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		toast = new ToastCore();
		addChild(toast);
	}
}