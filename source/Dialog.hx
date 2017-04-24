package;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import source.Person;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

/**
 * ...
 * @author kpded
 */
class Dialog extends FlxSpriteGroup
{
	private var label:FlxSprite;
	private var speech:FlxText;
	private var player:Person;
	private var otherPerson:Person;
	public var endOfTalk:Bool;
	private var byeBut:FlxButton;
	private var tradeBut:FlxButton;
	private var beFriendBut:FlxButton;

	public function new(person1:Person, person2:Person) 
	{
		super();
		player = person1;
		otherPerson = person2;
		endOfTalk = false;
		byeBut = new FlxButton(360, 660, "bye", byeCallback);
		tradeBut = new FlxButton(360, 600, "trade", tradeCallback);
		beFriendBut = new FlxButton(360, 600, "let's be friends", beFriendsCallback);
		defineTalk();		
	}
	
	public function defineTalk():Void
	{
		label = new FlxSprite(200, 410);
		label.makeGraphic(400, 300, FlxColor.GRAY);
		add(label);
		if (checkFriend(player, otherPerson))
		{
			if (checkPersonWantTrade())
			{
				if (checkTradable())
				{
					//first check whether the other person doesn't wear pants to deal with s ending (grammar stuff)
					var speechLine = '';
					if (otherPerson.goodStr == 'pants')					
					{
						speechLine = ("Hi friend! I don't have " + otherPerson.absentWear + ". But I have 2 " + otherPerson.goodStr + ". I see you can help me. Let's trade.");
						
					} else if (otherPerson.goodStr == 'coin')
					{
						speechLine = ("Hi friend! I don't have " + otherPerson.absentWear + ". But I have a " + otherPerson.goodStr + ". I see you can help me. Let's trade.");
					} else
					{
						speechLine = ("Hi friend! I don't have " + otherPerson.absentWear + ". But I have 2 " + otherPerson.goodStr + "s. I see you can help me. Let's trade.");
					}
					speech = new FlxText(210, 420, 380, speechLine, 12);
					add(speech);
					add(byeBut);
					add(tradeBut);
				} else
				{
					var speechLine = ("Hi friend! I don't have " + otherPerson.absentWear + ". Unfortunately you can't help me.");
					speech = new FlxText(210, 420, 380, speechLine, 12);
					add(speech);
					add(byeBut);
				}
			} else
			{
				var speechLine = "Hi friend! I don't have time to talk, going to winner's exit.";
				speech = new FlxText(210, 420, 380, speechLine, 12);
				add(speech);
				add(byeBut);
			}
		} else
		{
			if (checkFriendOfFriend())
			{
				var speechLine = "I don't know you! But I've heard a few words about you from one of my friends.";
				speech = new FlxText(210, 420, 380, speechLine, 12);
				add(speech);
				add(beFriendBut);
				add(byeBut);
			} else
			{
				var speechLine = "I don't know you! Go away. Try to talk to one my friends.";
				speech = new FlxText(210, 420, 380, speechLine, 12);
				add(speech);
				add(byeBut);
			}
		}
	}
	
	private function checkFriend(p1:Person, p2:Person):Bool
	{
		if (p1.newFriends.indexOf(p2) > -1)
		{
			return true;
		} else if (p1.coreFriends.indexOf(p2) > -1)
		{
			return true;
		} else
		{
			return false;
		}
	}
	
	private function checkFriendOfFriend():Bool
	{
		var friendOfFriend = false;
		for (p in player.coreFriends)
		{
			if (checkFriend(p, otherPerson))
			{
				friendOfFriend = true;
			}
		}
		for (p in player.newFriends)
		{
			if (checkFriend(p, otherPerson))
			{
				friendOfFriend = true;
			}
		}
		return friendOfFriend;
	}
	
	private function checkTradable():Bool
	{
		return (player.goodStr == otherPerson.absentWear);
	}
	
	private function checkPersonWantTrade():Bool
	{
		return (otherPerson.absentWear != '');
	}
	
	private function byeCallback():Void
	{
		endOfTalk = true;
	}
	
	private function tradeCallback():Void
	{
		player.giveGood(otherPerson.goodStr);
		otherPerson.good.kill();
		otherPerson.goodStr = '';
		otherPerson.absentWear = '';
		otherPerson.dress(true, true, true);
		endOfTalk = true;
	}
	
	private function beFriendsCallback():Void
	{
		player.getNewFriend(otherPerson);
		otherPerson.getNewFriend(player);
		defineTalk();
	}
	
}