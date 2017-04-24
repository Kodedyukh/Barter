package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import openfl.geom.Point;
import source.Person;
import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import flixel.text.FlxText;

enum GameMode
{
	Pause;
	Walk;
	Talk;
	ShowFriends;
}

class PlayState extends FlxState
{
	private var player:Person;
	private var society:FlxTypedSpriteGroup<Person>;
	private var currentGameMode:GameMode;
	private var investigatedPerson:Person;
	private var dialog:Dialog;
	private var exitPoint:Point;
	private var enterPoint:Point;
	private var bank:FlxSprite;
	private var score:Int;
	private var scoreText:FlxText;
	private var label:FlxSpriteGroup;
	private var missionText:FlxText;
	private var firstCoinLabelShow:Bool;
	
	override public function create():Void
	{
		
		score = 0;
		var bg = new FlxSprite();
		bg.loadGraphic("assets/images/background.png", false, 800, 800);
		add(bg);
		currentGameMode = Walk;
		exitPoint = new Point(760, 20);
		enterPoint = new Point(760, 760);
		var exiteGate = new FlxSprite(exitPoint.x, exitPoint.y);
		exiteGate.makeGraphic(20, 20, FlxColor.GREEN);
		var exitGateSign = new FlxText(750, 5, 100, "Exit", 10);
		add(exitGateSign);
		add(exiteGate);
		var enterGate = new FlxSprite(enterPoint.x, enterPoint.y);
		enterGate.makeGraphic(20, 20, FlxColor.RED);
		var enterGateSign = new FlxText(750, 745, 100, "Enter", 10);
		add(enterGateSign);
		add(enterGate);
		bank = new FlxSprite(10, 380);
		bank.makeGraphic(40, 40, FlxColor.WHITE);
		var bankSign = new FlxText(10, 365, 80, "Bank", 10);
		add(bankSign);
		add(bank);
		scoreText = new FlxText(5, 5, 100, "Score " + scoreText, 14);
		add(scoreText);
		society = new FlxTypedSpriteGroup<Person>();
		var randomizer = new FlxRandom();
		for (i in 0...30)
		{
			var nPersonX = randomizer.int(10, 770);
			var nPersonY = randomizer.int(10, 770);
			var person = new Person(nPersonX, nPersonY, "" + i, false);
			person.randomlyDress();
			person.assignRandomGood();
			society.add(person);
			FlxMouseEventManager.add(person, onPersonMouseDown);
		}
		add(society);
		player = new Person(10 , 10, "0", true);
		player.getRandomFriends(society.members);
		player.giveGood(player.coreFriends[0].absentWear);
		add(player);		
		society.forEach(socialize);
		label = new FlxSpriteGroup(200, 410);
		var background = new FlxSprite(0, 0);
		background.makeGraphic(400, 300, FlxColor.GRAY);
		var missionString = "You are playing for guy in top left corner, who wears red hat. You have to collect coins and put into your bank account. You collect them by exchanging goods with friends. Make you first exchange with one of your friends (men with blue bars above heads). Control your character with arrows (or WASD), approach them and hit SPACE button. But they accept just things they don’t have, it could be hat, shirt or pants. Initially you can provide them with pants (in your left hand).";
		missionText = new FlxText(10, 10, 380, missionString, 14);
		label.add(background);
		label.add(missionText);
		add(label);
		player.firstExchange = true;
		firstCoinLabelShow = false;
		FlxMouseEventManager.add(label, onLabelMouseDown, true);
		super.create();		
	}
	
	public function socialize(person:Person):Void
	{
		person.getRandomFriends(society.members);
	}
	
	public function personInteract(person:Person):Void
	{
		if (dialog == null)
		{
			dialog = new Dialog(player, person);
			add(dialog);
			manageMode(Talk);
		}
	}
	
	public function playerCollisionCheck(otherPerson:Person):Void
	{
		if (FlxG.overlap(player, otherPerson))
		{
			personInteract(otherPerson);
		}
	}
	
	public function checkAllClothes(person:Person):Void
	{
		if (person.absentWear == '' && !person.finish)
		{
			
			person.finish = true;
			person.targetPoint = exitPoint;
			if (person.playerRelation == 'core')
			{
				createNewPerson(true);
			} else
			{
				createNewPerson(false);
			}
			//tutorial stuff
			if (!player.firstExchangeDone && player.firstExchange)
			{
				player.firstExchangeDone = true;
				player.firstNewFriend = true;
				missionText.text = "You can get new friends by going to them and hitting SPACE button. But a person agrees to be your friend only if he is a friend of your friend. If you click at any person you can see his friends going around with yellow buttons over head. Go find a new friend.";
				add(label);
			}
			
		}
	}
	
	public function bankInteraction(_player:Person, _bank:FlxSprite):Void
	{
		if (player.goodStr == "coin")
		{
			score++;
			player.good.kill();
			player.giveGood('pants');
			//tutorial stuff
			if (player.firstBank && !player.firstBankDone)
			{
				player.firstBankDone = true;
				missionText.text = "Go earn some more money!";
				add(label);
			}
		}
	}
	
	public function createNewPerson(corePerson:Bool):Void
	{
		var person = new Person(enterPoint.x, enterPoint.y, "" + (society.length + 1), false);
		person.randomlyDress();
		person.assignRandomGood();
		socialize(person);
		if (corePerson)
		{
			person.playerRelation = 'core';
			person.addFriendshipBar('core');
			player.coreFriends.push(person);
		}
		society.add(person);
		trace(player.coreFriends.length);
		FlxMouseEventManager.add(person, onPersonMouseDown);
	}
	
	public function onPersonMouseDown(person:Person):Void
	{
		if (!person.clicked)
		{
			person.showFriends();
			manageMode(ShowFriends);
			person.clicked = true;
		} else 
		{
			person.hideFriends();
			manageMode(Walk);
			person.clicked = false;
		}
	}
	
	public function onLabelMouseDown(label:FlxSpriteGroup):Void
	{
		remove(label);
	}
	
	public function manageMode(nextMode:GameMode):Void
	{
		currentGameMode = nextMode;
	}

	override public function update(elapsed:Float):Void
	{
		if (currentGameMode == Walk)
		{
			if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
			{
				player.manuallyMove('right');
			}
			if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
			{
				player.manuallyMove('left');
			}
			if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W)
			{
				player.manuallyMove('up');
			}
			if (FlxG.keys.pressed.DOWN|| FlxG.keys.pressed.S)
			{
				player.manuallyMove('down');
			}
			if (FlxG.keys.justPressed.SPACE)
			{
				society.forEach(playerCollisionCheck);
				FlxG.overlap(player, bank, bankInteraction);
			}
			society.forEachAlive(checkAllClothes);
			scoreText.text = "Score " + score;
			if (player.firstCoin && !player.firstCoinDone && !firstCoinLabelShow)
			{
				missionText.text = "New friends have a green bar over head and they have a friendship with you for a limited time - 20 seconds. Find someone with yellow coin in hand and trade with him but remember they trade only with friends.";
				firstCoinLabelShow = true;
				add(label);
			}
			if (player.goodStr == 'coin' && player.firstCoin && !player.firstCoinDone)
			{
				player.firstCoinDone = true;
				missionText.text = "Well Done you get your first coin! Now rush into the bank to put it on your account by hitting SPACE button when you near it.";
				player.firstBank = true;
			}
			super.update(elapsed);
		} else if (currentGameMode == ShowFriends)
		{
			
		} else if (currentGameMode == Talk)
		{
			dialog.update(elapsed);
			if (dialog.endOfTalk)
			{
				remove(dialog);
				dialog = null;
				manageMode(Walk);
			}
		}
		
	}
}