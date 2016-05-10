﻿package {	import flash.events.EventDispatcher;	import flash.display.Sprite;	import flash.events.KeyboardEvent;	import flash.events.*;	import flash.ui.Mouse;	import flash.ui.Keyboard;	import flash.utils.Timer;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;	public class GameController extends Sprite	{		public static const GAME_OVER:String = "gameOver";		public static const GAME_FINISH:String = "gameFinish";		private var _bricksM:BrickMatrix;		private var _bricks:Array;		private var _ball:Ball;		private var _board:Board;		private var _stage:Sprite;		private var _isGaming:Boolean = false;		private var _gameTimer:Timer;		private var _ballSpeedX:Number = 5;		private var _ballSpeedY:Number = -5;		private var _dist:Number = 0;		private var _count:uint = 0;		private var _countBricks:uint = 0;		private var _scoreText:TextField;		private var _hintText:TextField;		private var _format:TextFormat = new TextFormat();		public function GameController(_stage:Sprite,_bricksM:BrickMatrix,_board:Board,_ball:Ball, _scoreText:TextField, _hintText:TextField)		{			// constructor code			this._stage = _stage;			this._bricksM = _bricksM;			this._board = _board;			this._ball = _ball;			this._bricks = _bricksM.getBricksArray();			this._scoreText = _scoreText;			this._hintText=_hintText;			this._stage.addChild(this._hintText);						_stage.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyBoardHandler);			_stage.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);			_gameTimer = new Timer(5);			_gameTimer.addEventListener(TimerEvent.TIMER,timerHandler);			_bricksM.addEventListener(BrickMatrix.HIT_EVENT, hitBirck);			addListenersToBricks();		}		private function addListenersToBricks():void		{			var brick:Brick;			for (var i:uint=0; i < _bricks.length; i++)			{				brick = _bricks[i] as Brick;				brick.addEventListener(Event.ENTER_FRAME, hitBirck);			}		}		private function hitBirck(e:Event):void		{			var brick:Brick = e.target as Brick;			if (brick.hitTestObject(_ball))			{				_ballSpeedY =  -  _ballSpeedY;				brick.removeEventListener(Event.ENTER_FRAME, hitBirck);				brick.addEventListener(Event.ENTER_FRAME, disappear);				_countBricks +=  1;				if (brick.getColor() == 0)				{					_count +=  1;				}				else if (brick.getColor() == 1)				{					_count +=  2;									}				else if (brick.getColor() == 2)				{					_count +=  4;				}				else if (brick.getColor() == 3)				{					_count +=  8;				}				else if (brick.getColor() == 4)				{					_count +=  20;				}			}		}		private function disappear(e:Event):void		{			var brick:Brick = e.target as Brick;			brick.x +=  4;			brick.y +=  1;			brick.width -=  8;			brick.height -=  2;			if (brick.width == 0 && brick.height == 0)			{				_bricksM.removeChild(brick);				brick.removeEventListener(Event.ENTER_FRAME, disappear);			}		}		private function timerHandler(e:TimerEvent):void		{			_format.color = 0x000000;			_format.size = 20;			_format.font = "Arial Rounded MT Bold";			_format.align = TextFormatAlign.LEFT;			_scoreText.setTextFormat(_format);			_scoreText.text = "Score:" + _count;			if (_countBricks == 28)			{				_gameTimer.stop();				dispatchEvent(new Event(GAME_FINISH));			}			if (_ball.x < _ball.BALL_WIDTH / 2 - 10 || _ball.x > _stage.stage.stageWidth - _ball.BALL_WIDTH / 2 - 15)			{				_ballSpeedX =  -  _ballSpeedX;			}			if (_ball.y < _ball.BALL_HEIGHT / 2 - 10)			{				_ballSpeedY =  -  _ballSpeedY;			}			if (_ball.y > _stage.stage.stageHeight - _board.BOARD_HEIGHT)			{				gameOver();				return;			}			if (_ball.hitTestObject(_board))			{				_ballSpeedY=- _ballSpeedY;				_ballSpeedX= _ballSpeedX;			}			_ball.x +=  _ballSpeedX;			_ball.y +=  _ballSpeedY;		}		private function gameStart():void		{			_gameTimer.start();		}		private function gameOver():void		{			_gameTimer.stop();			_gameTimer.reset();			_stage.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);			dispatchEvent(new Event(GAME_OVER));		}		private function mouseMoveHandler(e:Event):void		{			if (_isGaming)			{				Mouse.hide();				_board.x = mouseX - _board.BOARD_WIDTH / 2;			}		}		private function keyBoardHandler(e:KeyboardEvent):void		{			switch (e.keyCode)			{				case Keyboard.SPACE :					if (! _isGaming)					{						_isGaming = true;						this._stage.removeChild(_hintText);						gameStart();						break;					}				case Keyboard.LEFT :					if (_isGaming)					{						_board.x -=  30;						break;					}				case Keyboard.RIGHT :					if (_isGaming)					{						_board.x +=  30;						break;					}							}		}	}}