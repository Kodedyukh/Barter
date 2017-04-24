package source;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRandom;
import haxe.ds.ObjectMap;
import openfl.Assets;
import openfl.geom.Point;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author kpded
 */
class Person extends FlxSpriteGroup
{
	public var body:FlxSprite;
	public var hat:FlxSprite;
	public var shirt:FlxSprite;
	public var pants:FlxSprite;
	public var id:String;
	public var ai:Bool;
	public var good:FlxSprite;
	public var goodStr:String;
	public var coreFriends:Array<Person>;
	public var newFriends:Array<Person>;
	public var frameCounter:ObjectMap<Person, Int>;
	private var framesToLooseNewFriend:Int;
	private var movement:Point;
	public var targetPoint:Point;
	private var speed:Float;
	public var friendshipBar:FlxSprite;
	public var playerRelation:String;
	public var absentWear:String;
	public var finish:Bool;
	public var clicked:Bool;
	//boolen variables for tutorial
	public var firstExchange:Bool;
	public var firstExchangeDone:Bool;
	public var firstNewFriend:Bool;
	public var firstNewFriendDone:Bool;
	public var firstCoin:Bool;
	public var firstCoinDone:Bool;
	public var firstBank:Bool;
	public var firstBankDone:Bool;

	public function new(x:Float, y:Float, identifier:String, playerControl:Bool) 
	{
		super(x, y);
		id = identifier;
		ai = !playerControl;
		body = new FlxSprite(0, 0);
		var bodyBitmapData = Assets.getBitmapData("assets/images/body.png", false);
		var bodyBitmapDataWidth:Float = bodyBitmapData.width;
		var bodyBitmapDataHeight:Float = bodyBitmapData.height;
		body.loadGraphic(bodyBitmapData, false, 30, 52);
		goodStr = 'none';
		//number of frames to loose connection with new friend - 20 seconds with 60 fps
		framesToLooseNewFriend = 20 * 60;
		//some initial constants
		coreFriends = [];
		newFriends = [];
		frameCounter = new ObjectMap<Person, Int>();		
		if (ai)
		{
			speed = 0.5;
		} else
		{
			speed = 1;
		}
		playerRelation = 'none';
		movement = new Point();
		targetPoint = new Point(x, y);
		absentWear = '';
		finish = false;
		clicked = false;
		add(body);
		//if created person is player dress it with fancy hat
		if (playerControl) {
			dressPlayer();
			//tutorial constants only for player
			firstExchange = false;
			firstExchangeDone= false;
			firstNewFriend = false;
			firstNewFriendDone = false;
			firstCoin = false;
			firstCoinDone = false;
			firstBank = false;
			firstBankDone = false;
		}
	}
	
	public function dressPlayer():Void
	{
		hat = new FlxSprite(0, 0);
		var hatBitmapData = Assets.getBitmapData("assets/images/playerHat.png", false);
		var hatBitmapDataWidth:Float = hatBitmapData.width;
		var hatBitmapDataHeight:Float = hatBitmapData.height;
		hat.loadGraphic(hatBitmapData, false, 30, 52);
		add(hat);
		shirt = new FlxSprite(0, 0);
		var shirtBitmapData = Assets.getBitmapData("assets/images/shirt.png", false);
		var shirtBitmapDataWidth:Float = shirtBitmapData.width;
		var shirtBitmapDataHeight:Float = shirtBitmapData.height;
		shirt.loadGraphic(shirtBitmapData, false, 30, 52);
		add(shirt);
		pants = new FlxSprite(0, 0);
		var pantsBitmapData = Assets.getBitmapData("assets/images/pants.png", false);
		var pantsBitmapDataWidth:Float = pantsBitmapData.width;
		var pantsBitmapDataHeight:Float = pantsBitmapData.height;
		pants.loadGraphic(pantsBitmapData, false, 30, 52);
		add(pants);
	}
	
	public function dress(hasHat:Bool, hasShirt:Bool, hasPants:Bool):Void
	{
		if (hasHat)
		{
			hat = new FlxSprite(0, 0);
			var hatBitmapData = Assets.getBitmapData("assets/images/hat.png", false);
			var hatBitmapDataWidth:Float = hatBitmapData.width;
			var hatBitmapDataHeight:Float = hatBitmapData.height;
			hat.loadGraphic(hatBitmapData, false, 30, 52);
			add(hat);
		}
		if (hasShirt)
		{
			shirt = new FlxSprite(0, 0);
			var shirtBitmapData = Assets.getBitmapData("assets/images/shirt.png", false);
			var shirtBitmapDataWidth:Float = shirtBitmapData.width;
			var shirtBitmapDataHeight:Float = shirtBitmapData.height;
			shirt.loadGraphic(shirtBitmapData, false, 30, 52);
			add(shirt);
		}
		if (hasPants)
		{
			pants = new FlxSprite(0, 0);
			var pantsBitmapData = Assets.getBitmapData("assets/images/pants.png", false);
			var pantsBitmapDataWidth:Float = pantsBitmapData.width;
			var pantsBitmapDataHeight:Float = pantsBitmapData.height;
			pants.loadGraphic(pantsBitmapData, false, 30, 52);
			add(pants);
		}
	}
	
	public function randomlyDress():Void
	{
		var randomizer = new FlxRandom();
		absentWear = randomizer.getObject(["hat", "shirt", "pants"]);
		switch (absentWear)
		{
			case 'hat':
				dress(false, true, true);
			case 'shirt':
				dress(true, false, true);
			case 'pants':
				dress(true, true, false);
		}
	}
	
	public function giveGood(givenGood:String):Void
	{
		switch (givenGood)
		{
			case 'hat':
				var bitmapData = Assets.getBitmapData("assets/images/goodsSkins/hat.png", false);
				good = new FlxSprite(-10, 30);
				good.loadGraphic(bitmapData, false);
				goodStr = givenGood;
				add(good);
			case 'shirt':
				var bitmapData = Assets.getBitmapData("assets/images/goodsSkins/shirt.png", false);
				good = new FlxSprite(-10, 30);
				good.loadGraphic(bitmapData, false);
				goodStr = givenGood;
				add(good);
			case 'pants':
				var bitmapData = Assets.getBitmapData("assets/images/goodsSkins/pants.png", false);
				good = new FlxSprite(-10, 30);
				good.loadGraphic(bitmapData, false);
				goodStr = givenGood;
				add(good);
			case 'coin':
				var bitmapData = Assets.getBitmapData("assets/images/goodsSkins/coin.png", false);
				good = new FlxSprite(-10, 30);
				good.loadGraphic(bitmapData, false);
				goodStr = givenGood;
				add(good);
		}
	}
	
	public function assignRandomGood():Void
	{
		if (absentWear == 'hat')
		{
			var randomizer = new FlxRandom();
			var chosenGood = randomizer.getObject(["shirt", "pants", "coin"]);
			giveGood(chosenGood);
		}
		if (absentWear == 'shirt')
		{
			var randomizer = new FlxRandom();
			var chosenGood = randomizer.getObject(["hat", "pants", "coin"]);
			giveGood(chosenGood);
		}
		if (absentWear == 'pants')
		{
			var randomizer = new FlxRandom();
			var chosenGood = randomizer.getObject(["hat", "shirt", "coin"]);
			giveGood(chosenGood);
		}
	}
	
	public function getRandomFriends(friendCandidates:Array<Person>):Void
	{
		var randomizer = new FlxRandom();
		var candidates = friendCandidates.copy();
		candidates.remove(this);
		/*for (p in friendCandidates.members)
		{
			candidates.push(p);
		}*/
		for (i in 0...3)
		{
			var friend = randomizer.getObject(candidates);
			if (!ai) {
				friend.playerRelation = 'core';
				friend.addFriendshipBar('core');
			}
			coreFriends.push(friend);
			candidates.remove(friend);
		}
	}
	
	public function getNewFriend(newFriend:Person):Void
	{
		//check that new friend is not among core friends
		if (coreFriends.indexOf(newFriend) < 0)
		{
			if (!ai) {
				newFriend.playerRelation = 'friend';
				newFriend.addFriendshipBar('friend');
			}
			newFriends.push(newFriend);
			frameCounter.set(newFriend, framesToLooseNewFriend);
		}
		//tutorial stuff
		if (!ai)
		{
			if (firstNewFriend && !firstNewFriendDone)
			{
				firstNewFriendDone = true;
				firstCoin = true;
			}
		}
	}
	
	public function addFriendshipBar(status:String):Void
	{
		switch (status)
		{
			case 'core':
				friendshipBar = new FlxSprite(0 , -5);
				friendshipBar.makeGraphic(Math.round(width), 5, FlxColor.BLUE);
			case 'friend':
				friendshipBar = new FlxSprite(0 , -5);
				friendshipBar.makeGraphic(Math.round(width), 5, FlxColor.GREEN);
			case 'target':
				friendshipBar = new FlxSprite(0 , -5);
				friendshipBar.makeGraphic(Math.round(width), 5, FlxColor.YELLOW);
		}
		add(friendshipBar);
	}
	
	public function getMovement():Void
	{
		var currentPos = new Point(x, y);
		if (Point.distance(targetPoint, currentPos) > speed)
		{
			movement = targetPoint.subtract(currentPos);
			movement.normalize(speed);
		} else
		{
			//if distance to target point is less than speed - define new target
			//for NPCs only
			if (ai) {
				//if NPC get all the clothes it don't need to find new target
				if (!finish){
					getTarget();
				} else
				{
					//kill NPCs that finished and reached the exit gate
					kill();
				}
			} else {
				//player should stay in rest when near target point
				movement = new Point();
			}
		}			
	}
	
	public function manuallyMove(direction:String):Void
	{
		switch (direction)
		{
			case 'right':
				targetPoint.x = Math.min(targetPoint.x + 2, FlxG.width - width);
				targetPoint.y = y;
			case 'left':
				targetPoint.x = Math.max(targetPoint.x - 2, 0);
				targetPoint.y = y;
			case 'up':
				targetPoint.x = x;
				targetPoint.y = Math.max(targetPoint.y - 2, 0);
			case 'down':
				targetPoint.x = x;
				targetPoint.y = Math.min(targetPoint.y + 2, FlxG.height - height);
		}
		
	}
	
	public function getTarget(finish:Bool = false):Void
	{
		var randomizer = new FlxRandom();
		var deltaX = randomizer.int(Math.round(speed * 10), Math.round(speed * 20));
		var deltaY = randomizer.int(Math.round(speed * 10), Math.round(speed * 20));
		//check that target point is in screen boundaries
		var signX = 1;
		var signY = 1;
		if (x + deltaX + width< FlxG.width && x - deltaX > 0)
		{
			signX = randomizer.sign();
		} else
		{
			if (x + deltaX + width > FlxG.width)
			{
				signX = -1;
			} else
			{
				signX = 1;
			}
		}
		if (y + deltaY + height < FlxG.height && y - deltaY > 0)
		{
			signY = randomizer.sign();
		} else
		{
			if (y + deltaY + height > FlxG.height)
			{
				signY = -1;
			} else
			{
				signY = 1;
			}
		}
		targetPoint = new Point(x + signX * deltaX, y + signY * deltaY);
	}
	
	public function showFriends():Void
	{
		for (p in coreFriends)
		{
			p.addFriendshipBar('target');
		}
	}
	
	public function hideFriends():Void
	{
		for (p in coreFriends)
		{
			if (p.friendshipBar != null)
			{
				p.friendshipBar.kill();
			}
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		x += movement.x;
		y += movement.y;
		getMovement();
		for (i in frameCounter.keys())
		{
			if (frameCounter.get(i) > 0)
			{
				frameCounter.set(i, frameCounter.get(i)-1);
			}
			else
			{
				if (!ai)
				{
					i.friendshipBar.kill();
				}
				newFriends.remove(i);
				frameCounter.remove(i);
			}
		}		
		super.update(elapsed);
	}
}