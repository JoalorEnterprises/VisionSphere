package states.substates;

import frontend.Colorblind;

class FilterSubState extends FlxSubState
{
    var curSelected:Int = 0;
    var coolGrp:FlxTypedGroup<Alphabet>;
    var filters:Array<String> = [
        'None',
        'Deuteranopia',
        'Deuteranomaly',
        'Protanopia',
        'Protanomaly',
        'Tritanopia',
        'Tritanomaly',
        'Achromatomaly',
        'Gameboy',
        'Virtual Boy',
        'Monochrome',
        'Inverted',
        'What Even',
        'Random'
    ];

    public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        bg.alpha = 0.65;
        add(bg);

        coolGrp = new FlxTypedGroup<Alphabet>();
        add(coolGrp);

        for (i in 0...filters.length)
        {
            var label:Alphabet = new Alphabet(90, 320, filters[i], true);
            label.isMenuItem = true;
            label.targetY = i;
            coolGrp.add(label);
        }

        changeSelection();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        var up = Input.is('up') || (gamepad != null ? Input.gamepadIs('gamepad_up') : false);
        var down = Input.is('down') || (gamepad != null ? Input.gamepadIs('gamepad_down') : false);
        var accept = Input.is('accept') || (gamepad != null ? Input.gamepadIs('gamepad_accept') : false);
        var exit = Input.is('exit') || (gamepad != null ? Input.gamepadIs('gamepad_exit') : false);

        if (up || down)
        {
            FlxG.sound.play(Paths.sound('scroll'));
            changeSelection(up ? -1 : 1);
        }

        if (accept)
        {
            FlxG.sound.play(Paths.sound('confirm'));

            switch(curSelected)
            {
                case 0:
                    SaveData.saveData('colorBlindFilter', -1);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 1:
                    SaveData.saveData('colorBlindFilter', 0);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 2:
                    SaveData.saveData('colorBlindFilter', 1);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 3:
                    SaveData.saveData('colorBlindFilter', 2);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 4:
                    SaveData.saveData('colorBlindFilter', 3);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 5:
                    SaveData.saveData('colorBlindFilter', 4);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 6:
                    SaveData.saveData('colorBlindFilter', 5);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 7:
                    SaveData.saveData('colorBlindFilter', 6);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 8:
                    SaveData.saveData('colorBlindFilter', 7);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 9:
                    SaveData.saveData('colorBlindFilter', 8);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 10:
                    SaveData.saveData('colorBlindFilter', 9);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 11:
                    SaveData.saveData('colorBlindFilter', 10);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 12:
                    SaveData.saveData('colorBlindFilter', 11);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'));
                case 13:
                    SaveData.saveData('colorBlindFilter', 12);
                    Colorblind.updateColorBlindFilter(SaveData.getData('colorBlindFilter'), FlxG.random.float(0, 1));
            }
            close();
        }
        else if (exit)
        {
            FlxG.sound.play(Paths.sound('cancel'));
            close();
        }

        for (num => item in coolGrp.members)
        {
            item.targetY = num - curSelected;
            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    private function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, filters.length - 1);
    }
}