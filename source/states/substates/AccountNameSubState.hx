package states.substates;

import flixel.addons.ui.FlxUIInputText;

import states.AccountState;

class AccountNameSubState extends FlxSubState
{
    var input:FlxUIInputText;

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
        bg.alpha = 0.65;
        add(bg);

        var text:FlxText = new FlxText(0, 0, 0, "Enter a Username", 32);
        text.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.screenCenter();
        add(text);

        input = new FlxUIInputText(10, 10, FlxG.width, '', 8);
        input.setFormat(Paths.font('vcr.ttf'), 96, FlxColor.WHITE, FlxTextAlign.CENTER);
        input.alignment = CENTER;
        input.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
        input.screenCenter(XY);
        input.y += 50;
        input.backgroundColor = 0xFF000000;
        input.lines = 1;
        input.caretColor = 0xFFFFFFFF;
        add(input);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        input.hasFocus = true;

        if (Input.is('accept') && input.text != '')
        {
            trace('changed username to: ' + input.text);

            AccountState.instance.usernameTxt.text = SaveData.username;
            SaveData.username = input.text;
            SaveData.saveSettings();
            close();
        }
        else if (Input.is('exit'))
            close();
    }
}