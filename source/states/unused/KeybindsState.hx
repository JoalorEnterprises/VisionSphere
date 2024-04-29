package states.unused;

class KeybindsState extends FlxState
{
    var grpControls:FlxTypedGroup<Alphabet>;
    var controlsStrings:Array<String> = ["unused"];
    var curSelected:Int = 0;

    override public function create()
    {
        trace("this is old and scuffed why are you here");

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('theme/${SaveData.settings.get("theme")}'));
        add(bg);

        grpControls = new FlxTypedGroup<Alphabet>();
        add(grpControls);

        for (i in 0...controlsStrings.length)
        {
            var controlLabel:Alphabet = new Alphabet(90, 320, controlsStrings[i], true);
            controlLabel.isMenuItem = true;
            controlLabel.targetY = i;
            grpControls.add(controlLabel);
        }

        changeSelection();

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var up = Input.is('up') || (gamepad != null ? Input.gamepadIs('gamepad_up') : false);
        var down = Input.is('down') || (gamepad != null ? Input.gamepadIs('gamepad_down') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (up || down)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(Input.is('up') ? -1 : 1);
        }

        if (exit)
        {
            FlxG.sound.play(Paths.sound('cancel'));
            FlxG.switchState(MenuState.new);
        }

        for (num => item in grpControls.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    private function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, controlsStrings.length - 1);
    }
}