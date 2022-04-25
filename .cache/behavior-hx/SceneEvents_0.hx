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
import box2D.collision.shapes.B2Shape;

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



class SceneEvents_0 extends SceneScript
{
	public var _npcengaged:Bool;
	public var _readytotalk:Bool;
	public var _sell:Bool;
	public var _buy:Bool;
	public var _npcspeecg:String;
	public var _x:Bool;
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("npc_engaged", "_npcengaged");
		_npcengaged = false;
		nameMap.set("ready_to_talk", "_readytotalk");
		_readytotalk = false;
		nameMap.set("sell", "_sell");
		_sell = false;
		nameMap.set("buy", "_buy");
		_buy = false;
		nameMap.set("npc speecg", "_npcspeecg");
		_npcspeecg = "";
		nameMap.set("x", "_x");
		_x = true;
		
	}
	
	override public function init()
	{
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(10));
				g.drawString("" + (("Seeds: ") + (("" + (Engine.engine.getGameAttribute("Seed_Count") : Float)))), 30, 30);
				g.drawString("" + (("Turnips: ") + (("" + (Engine.engine.getGameAttribute("Turnips") : Float)))), 30, 60);
				g.drawString("" + (("Money: ") + (("" + (Engine.engine.getGameAttribute("money") : Float)))), 30, 90);
			}
		});
		
		/* ======================== Specific Actor ======================== */
		addActorEntersRegionListener(getRegion(0), function(a:Actor, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAs(getActor(1), a))
			{
				switchScene(GameModel.get().scenes.get(5).getID(), null, createCrossfadeTransition(0.2));
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(13));
				g.drawString("" + _npcspeecg, 300, 30);
				if((_npcengaged == false))
				{
					_npcspeecg = "Press Enter to buy a seed and press Backspace to sell a turnip";
				}
				else if((_npcengaged == true))
				{
					if((_buy == true))
					{
						Engine.engine.setGameAttribute("money", ((Engine.engine.getGameAttribute("money") : Float) - 1));
						Engine.engine.setGameAttribute("Seed_Count", ((Engine.engine.getGameAttribute("Seed_Count") : Float) + 1));
						_npcspeecg = "Thank you come again";
						runLater(1000 * 5, function(timeTask:TimedTask):Void
						{
							_npcspeecg = "Press Enter to buy a seed and press Backspace to sell a turnip";
						}, null);
						_buy = false;
						_sell = false;
					}
					else if((_sell == true))
					{
						if(((Engine.engine.getGameAttribute("Turnips") : Float) > 0))
						{
							Engine.engine.setGameAttribute("money", ((Engine.engine.getGameAttribute("money") : Float) + 2));
							Engine.engine.setGameAttribute("Turnips", ((Engine.engine.getGameAttribute("Turnips") : Float) - 1));
							_npcspeecg = "Thank you come again";
							runLater(1000 * 5, function(timeTask:TimedTask):Void
							{
								_npcspeecg = "Press Enter to buy a seed and press Backspace to sell a turnip";
							}, null);
							_buy = false;
							_sell = false;
						}
						else
						{
							_npcspeecg = "Looks like you don't have any turnips to sell";
							runLater(1000 * 5, function(timeTask:TimedTask):Void
							{
								_npcspeecg = "Press Enter to buy a seed and press Backspace to sell a turnip";
							}, null);
							_buy = false;
							_sell = false;
						}
					}
				}
				runLater(1000 * 5, function(timeTask:TimedTask):Void
				{
					_npcengaged = false;
				}, null);
			}
		});
		
		/* ======================= Every N seconds ======================== */
		runPeriodically(1000 * 5, function(timeTask:TimedTask):Void
		{
			if(wrapper.enabled)
			{
				playSound(getSound(20));
				fadeInForAllSounds(30);
				runLater(1000 * 300, function(timeTask:TimedTask):Void
				{
					fadeOutForAllSounds(30);
				}, null);
			}
		}, null);
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("enter", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				_sell = false;
				_buy = true;
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("backspace", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				_buy = false;
				_sell = true;
			}
		});
		
		/* ========================= Type & Type ========================== */
		addSceneCollisionListener(getActorType(2).ID, getActorType(11).ID, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_npcengaged = true;
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((((Engine.engine.getGameAttribute("Turnips") : Float) == 30) && _x))
				{
					g.setFont(getFont(17));
					g.drawString("" + "You did it! You got 30 turnips!", 200, 200);
					runLater(1000 * 10, function(timeTask:TimedTask):Void
					{
						_x = false;
					}, null);
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("esc", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				Engine.engine.setGameAttribute("Prev_Scene", getCurrentSceneName());
				switchScene(GameModel.get().scenes.get(1).getID(), createFadeOut(0.5, Utils.getColorRGB(0,0,0)), createFadeIn(0.5, Utils.getColorRGB(0,0,0)));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}