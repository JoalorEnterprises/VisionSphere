package states.games;

class MainMenuState extends FlxState
{
    override public function create()
    {
        var logo:FlxSprite = new FlxSprite().loadGraphic('game/2048/logo');
        logo.screenCenter(X);
        add(logo);

        var playBtn:FlxButton = new FlxButton(0, FlxG.height / 2 + 50, "Play", function()
        {
            return
        });
        playBtn.scale.set(2, 2);
        playBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        playBtn.label.screenCenter(XY);
        playBtn.screenCenter(XY);
        add(playBtn);

        var exitBtn:FlxButton = new FlxButton(0, playBtn.y + 70, "Exit", function()
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() 
	        {
	            FlxG.switchState(new states.MenuState(0));
	        });
        });
        exitBtn.scale.set(2, 2);
        exitBtn.label.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        exitBtn.label.screenCenter(XY);
        exitBtn.screenCenter(XY);
        add(exitBtn);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) 
        {
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
            {
                FlxG.switchState(new states.MenuState());
            });
            FlxG.sound.play(Paths.sound('cancel'));
        }
    }
}

class PlayState extends FlxState
{
    // wip
}

class WinState extends FlxState
{
    // wip
}