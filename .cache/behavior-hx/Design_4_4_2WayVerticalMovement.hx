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



class Design_4_4_2WayVerticalMovement extends ActorScript
{
	public var _UpControl:String;
	public var _DownControl:String;
	public var _MoveY:Float;
	public var _UseControls:Bool;
	public var _PreventHorizontalMovement:Bool;
	public var _StartX:Float;
	public var _UpAnimationIdle:String;
	public var _UpAnimation:String;
	public var _DownAnimationIdle:String;
	public var _Speed:Float;
	public var _DownAnimation:String;
	public var _UseAnimations:Bool;
	public var _StopTurning:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_MoveUp():Void
	{
		_MoveY = -1;
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_MoveDown():Void
	{
		_MoveY = 1;
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Up Control", "_UpControl");
		nameMap.set("Down Control", "_DownControl");
		nameMap.set("Move Y", "_MoveY");
		_MoveY = 0.0;
		nameMap.set("Use Controls", "_UseControls");
		_UseControls = true;
		nameMap.set("Prevent Horizontal Movement", "_PreventHorizontalMovement");
		_PreventHorizontalMovement = false;
		nameMap.set("Start X", "_StartX");
		_StartX = 0.0;
		nameMap.set("Up Animation (Idle)", "_UpAnimationIdle");
		nameMap.set("Up Animation", "_UpAnimation");
		nameMap.set("Down Animation (Idle)", "_DownAnimationIdle");
		nameMap.set("Speed", "_Speed");
		_Speed = 30.0;
		nameMap.set("Down Animation", "_DownAnimation");
		nameMap.set("Use Animations", "_UseAnimations");
		_UseAnimations = true;
		nameMap.set("Stop Turning", "_StopTurning");
		_StopTurning = true;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_StartX = actor.getX();
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_UseControls)
				{
					_MoveY = (asNumber(isKeyDown(_DownControl)) - asNumber(isKeyDown(_UpControl)));
				}
				actor.setYVelocity((_MoveY * _Speed));
				if(_PreventHorizontalMovement)
				{
					actor.setX(_StartX);
					actor.setXVelocity(0);
				}
				if((_StopTurning && !(_MoveY == 0)))
				{
					actor.setAngularVelocity(Utils.RAD * (0));
				}
				_MoveY = 0;
				if(_UseAnimations)
				{
					if((actor.getYVelocity() == 0))
					{
						if((actor.getAnimation() == _UpAnimation))
						{
							actor.setAnimation(_UpAnimationIdle);
						}
						else if((actor.getAnimation() == _DownAnimation))
						{
							actor.setAnimation(_DownAnimationIdle);
						}
					}
					else if((actor.getYVelocity() < 0))
					{
						actor.setAnimation(_UpAnimation);
					}
					else if((actor.getYVelocity() > 0))
					{
						actor.setAnimation(_DownAnimation);
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}