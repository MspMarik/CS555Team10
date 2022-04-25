package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;
import com.stencyl.graphics.ScaleMode;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Config;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.motion.*;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class ActorEvents_8 extends ActorScript
{
	public var _AlreadyPlanted:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Already_Planted", "_AlreadyPlanted");
		_AlreadyPlanted = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(2), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((actor.getAnimation() == "Grown"))
				{
					Engine.engine.setGameAttribute("Turnips", ((Engine.engine.getGameAttribute("Turnips") : Float) + 1));
					actor.setAnimation("Dirt");
					runLater(1000 * 2, function(timeTask:TimedTask):Void
					{
						_AlreadyPlanted = false;
					}, actor);
				}
				else if((((Engine.engine.getGameAttribute("Seed_Count") : Float) > 0) && (_AlreadyPlanted == false)))
				{
					_AlreadyPlanted = true;
					Engine.engine.setGameAttribute("Seed_Count", ((Engine.engine.getGameAttribute("Seed_Count") : Float) - 1));
					actor.setAnimation("Planted");
					runLater(1000 * (Engine.engine.getGameAttribute("growing_speed") : Float), function(timeTask:TimedTask):Void
					{
						actor.setAnimation("1");
						runLater(1000 * (Engine.engine.getGameAttribute("growing_speed") : Float), function(timeTask:TimedTask):Void
						{
							actor.setAnimation("2");
							runLater(1000 * (Engine.engine.getGameAttribute("growing_speed") : Float), function(timeTask:TimedTask):Void
							{
								actor.setAnimation("3");
								runLater(1000 * (Engine.engine.getGameAttribute("growing_speed") : Float), function(timeTask:TimedTask):Void
								{
									actor.setAnimation("Grown");
								}, actor);
							}, actor);
						}, actor);
					}, actor);
				}
			}
		});
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(2), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if(isKeyPressed("enter"))
				{
					actor.getLastCollidedActor().setAnimation("water");
					Engine.engine.setGameAttribute("growing_speed", 0.5);
					runLater(1000 * 2, function(timeTask:TimedTask):Void
					{
						Engine.engine.setGameAttribute("growing_speed", 2);
					}, actor);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}