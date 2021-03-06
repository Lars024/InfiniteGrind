package InfiniteGrind 
{
	
	/**
	 * ...
	 * @author Lars024
	 */
	
	import flash.display.MovieClip;
	import flash.filesystem.*;
	import flash.system.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.net.*;
	
	public class InfiniteGrind extends MovieClip
	{
		
		public const VERSION:String = "1.0";
		public const GAME_VERSION:String = "1.0.21";
		public const BEZEL_VERSION:String = "0.1.0";
		public const MOD_NAME:String = "InfiniteGrind";
		
		internal var gameObjects:Object;
		
		// Game object shortcuts
		internal var core:Object;/*IngameCore*/
		internal var cnt:Object;/*CntIngame*/
		internal var GV:Object;/*GV*/
		internal var SB:Object;/*SB*/
		internal var prefs:Object;/*Prefs*/
		
		// Mod loader object
		internal static var bezel:Object;
		internal static var logger:Object;
		internal static var storage:File;
		
		public function InfiniteGrind()
		{
			super();
		}
		
		public function bind(modLoader:Object, gameObjects:Object) : InfiniteGrind
		{
			
			bezel = modLoader;
			logger = bezel.getLogger("InfiniteGrind");
			logger.log("InfiniteGrind", "Initialization stage 1");
			storage = File.applicationStorageDirectory;
			this.gameObjects = gameObjects;
			this.core = gameObjects.GV.ingameCore;
			this.cnt = gameObjects.GV.main.cntScreens.cntIngame;
			this.SB = gameObjects.SB;
			this.GV = gameObjects.GV;
			this.prefs = gameObjects.prefs;
			logger.log("InfiniteGrind", "Initialization stage 2");
			addEventListener();
			
			logger.log("InfiniteGrind", "InfiniteGrind initialized!");
			return this;
		}
		
		private function setInitialXp(event:Object): void 
		{
			
			
			//Hopefully temporary requirement of hotkey press to set initial xp on game start
			var pE:KeyboardEvent = event.eventArgs.event;
			if (pE.charCode == 81){
				logger.log("InfiniteGrind", "key press detected");
				var xp:int;
				
				//Reset xp back to 0
				this.core.setXpToZero();
				
				//Get the previous best
				switch (this.core.battleMode ){
					case 0:
						logger.log("InfiniteGrind", "this is journey");
						xp = Number(GV.ppd.stageHighestXpsJourney[this.core.stageMeta.id].g());
						break;
					case 1:
						logger.log("InfiniteGrind", "this is endurance");
						xp = Number(GV.ppd.stageHighestXpsEndurance[this.core.stageMeta.id].g());
						break;
					default:
						logger.log("InfiniteGrind", "this is trail");
						xp = Number(GV.ppd.stageHighestXpsTrail[this.core.stageMeta.id].g());
						break;
				}
				
				//Correct for battletraits xp multiplier
				xp = Math.round(xp / GV.selectorCore.traitsXpMult.g());
				
				//Set the xp
				this.core.addXp(xp, false);
				
				logger.log("InfiniteGrind", "Xp set");
			}
			
			
		}
		
		private function divideXpByBattleTraitMulti(xp:int): int{
			return Math.round(xp / GV.selectorCore.traitsXpMult.g());
		}
		
		private function addEventListener(): void
		{
			bezel.addEventListener("ingameKeyDown", setInitialXp);
		}
		
		public function unload(): void
		{
			removeEventListener();
			bezel = null;
			logger = null;
		}
		
		private function removeEventListener(): void
		{
			bezel.removeEventListener("ingameKeyDown", setInitialXp);
		}
	}
	
}