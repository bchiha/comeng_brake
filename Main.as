﻿package {	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import fl.controls.ComboBox;	import fl.data.DataProvider;	import flash.display.DisplayObject;	import flash.ui.Keyboard;	import flash.events.KeyboardEvent;	import com.greensock.TweenLite;	import com.greensock.easing.*;	public class Main extends Sprite {		// proerties		private var input:KeyboardInput;		private var helpIcon:HelpIcon;		private var gaugeBrakeCylinder:Gauge;		private var gaugeDual:Gauge;		private var brakeHandle:BrakeHandle;		private var bvic:BVIC;		private var onAir:Boolean;		private var previousPressure:uint;		private var previousBPPressure:uint;		private var eqPressure:uint;		private var epCB:ToggleSwitch;		private var simulationType:ComboBox;		private var currentSimulation:String;		private var activeSimulation:DisplayObject;		private var tripleValve:TripleValve;		private var brakeValve:BrakeValve;		const VERSION:String = 'v1.0';		const MAX_REGULATING_VALVE:uint = 550;		const MIN_REGULATING_VALVE:uint = 410;		const EMERGENCY_PRESSURE:uint = 275;		const STEP_PRESSURE:uint = 35;		const SIMULATIONS:Array = [{label:"Gauges",data:"gauges"},		   {label:"Triple Valve",data:"tripleValve"},		   {label:"Brake Valve",data:"brakeValve"}];		const BC_GAUGE_X:uint = 600, BC_GAUGE_Y:uint = 150, D_GAUGE_X:uint = 850, D_GAUGE_Y:uint = 150;		// constructor		public function Main() {			init();		}		function init():void {			input = new KeyboardInput();			addChild(input);			this.version_txt.text = this.VERSION;			//set up gauges			gaugeBrakeCylinder = new Gauge(100,0x000000,500);			addChild(gaugeBrakeCylinder);			gaugeBrakeCylinder.x = this.BC_GAUGE_X;			gaugeBrakeCylinder.y = this.BC_GAUGE_Y;			//brake pipe/main reservior			gaugeDual = new Gauge(100,0x000000,1100,true);			addChild(gaugeDual);			gaugeDual.x = this.D_GAUGE_X;			gaugeDual.y = this.D_GAUGE_Y;			gaugeDual.setNeedle(750,"red");						focusGauges(true);			currentSimulation = "gauges";			//set up brake handle;			brakeHandle = new BrakeHandle();			brakeHandle.name = "brakeHandle";			addChild(brakeHandle);			brakeHandle.x = 100;			brakeHandle.y = 200;			previousPressure = 0;			previousBPPressure = MAX_REGULATING_VALVE;			eqPressure = MAX_REGULATING_VALVE;			graphics.lineStyle( 3, 0x0074B9 );			DrawingShapes.drawPolygon( graphics, 100, 267, 3, 5,-30 );			//set up bvic;			bvic = new BVIC();			bvic.name = "BVIC";			addChild(bvic);			bvic.x = 350;			bvic.y = 200;			//set EP C/B			epCB = new ToggleSwitch();			epCB.name = "epCB";			addChild(epCB);			epCB.x = 725;			epCB.y = 80;			//set up ComboBox			simulationType = new ComboBox();			simulationType.dataProvider = new DataProvider(this.SIMULATIONS);			simulationType.prompt = "Select Simulation";			simulationType.width = 150;			simulationType.dropdownWidth = 150;			simulationType.move(350,10);			simulationType.addEventListener(Event.CHANGE, onSimulationType);			addChild(this.simulationType);			//set up Help Icon			helpIcon = new HelpIcon();			addChild(helpIcon);			helpIcon.x = 950;			helpIcon.y = 22;			//listeners			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownx);			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpx);			stage.addEventListener(MouseEvent.CLICK, onMouseClick);			input.addEventListener(KeyboardInput.KEY_PRESSED,onKeyPressed);			bvic.addEventListener(BVIC.END_ANIMATION,onEndAnimation);			epCB.addEventListener(ToggleSwitch.END_ANIMATION,onEndAnimation);			brakeHandle.addEventListener(BrakeHandle.END_ANIMATION,onEndAnimation);		}		private function onSimulationType(event:Event):void {			if (currentSimulation == "gauges") {				focusGauges(false);			}			if (activeSimulation != null) {				removeChild(activeSimulation);				activeSimulation = null;			}			switch (simulationType.selectedItem.data) {				case "tripleValve" :					addTripleValve();					break;				case "brakeValve" :					addBrakeValve();					break;				case "gauges" :					focusGauges(true);			}			currentSimulation = simulationType.selectedItem.data;			stage.focus = null;		}		private function addTripleValve():void {			//add triple valve			tripleValve = new TripleValve();			addChild(tripleValve);			tripleValve.x = 500;			tripleValve.y = 450;			activeSimulation = tripleValve;		}		private function addBrakeValve():void {			brakeValve = new BrakeValve();			addChild(brakeValve);			brakeValve.x = 150;			brakeValve.y = 350;			activeSimulation = brakeValve;		}				private function focusGauges(enlarge:Boolean):void {			if (enlarge) {				TweenLite.to(this.gaugeBrakeCylinder, 1, {x:300, y:450, scaleX:1.5, scaleY:1.5, ease:Sine.easeOut});				TweenLite.to(this.gaugeDual, 1, {x:700, y:450, scaleX:1.5, scaleY:1.5, ease:Sine.easeOut});			} else {				TweenLite.to(this.gaugeBrakeCylinder, 1, {x:this.BC_GAUGE_X, y:this.BC_GAUGE_Y, scaleX:1, scaleY:1, ease:Sine.easeOut});								TweenLite.to(this.gaugeDual, 1, {x:this.D_GAUGE_X, y:this.D_GAUGE_Y, scaleX:1, scaleY:1, ease:Sine.easeOut});							}		}		private function onKeyPressed(event:KeyboardEvent):void {			if (input.keyO) {				bvic.setToOpen();			}			if (input.keyC) {				bvic.setToClosed();			}			if (input.keyE) {				epCB.toggleIt();			}			if (input.key0) {				brakeHandle.stepTo(0);			}			if (input.key1) {				brakeHandle.stepTo(1);			}			if (input.key2) {				brakeHandle.stepTo(2);			}			if (input.key3) {				brakeHandle.stepTo(3);			}			if (input.key4) {				brakeHandle.stepTo(4);			}			if (input.key5) {				brakeHandle.stepTo(5);			}			if (input.key6) {				brakeHandle.stepTo(6);			}			if (input.key7) {				brakeHandle.stepTo(7);			}			if (input.key8) {				brakeHandle.stepTo(8);			}		}		private function onEndAnimation(event:MouseEvent):void {			onMouseMovex(event);		}		private function onMouseDownx(event:MouseEvent):void {			if (event.target.name == "BVIC" || event.target.name == "brakeHandle") {				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMovex);			}		}		private function onMouseClick(event:MouseEvent):void {			if (event.target.name == "epCB") {				onMouseMovex(event);			}		}		private function onMouseMovex(event:MouseEvent):void {			onAir = epCB.switchState();			brakeHandle.setAir(onAir);			setBrakeCylinderGauge();			setDualGauge();		}		private function onMouseUpx(event:MouseEvent):void {			if (stage.hasEventListener(MouseEvent.MOUSE_MOVE)) {				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMovex);			}		}		private function setBrakeCylinderGauge():void {			var pressure:uint,step:uint;			step = brakeHandle.step();			if (onAir) {				//step range is from 0 to 70 and Emergency of 100				//adjust brake cylinder between 0 and 275 with regard to brake pipe pressure				pressure = Math.min((EMERGENCY_PRESSURE / 70) * step, EMERGENCY_PRESSURE);				if ((bvic.isOpen() || step == 100) && (pressure == 0 || pressure > previousPressure)) {					gaugeBrakeCylinder.setNeedle(pressure);					previousPressure = pressure;				}			} else {				if (bvic.isOpen() || step == 10) {					if (step == 0) {						pressure = 0;					} else if (step == 1) {						pressure = STEP_PRESSURE * 2;					} else if (step > 1 && step <= 7) {						pressure = STEP_PRESSURE * step;					} else {						pressure = EMERGENCY_PRESSURE;					}					gaugeBrakeCylinder.setNeedle(pressure);				}			}		}		private function setDualGauge():void {			var step:uint,pressure:uint,position:String;			step = brakeHandle.step();			if (onAir) {				//step range is from 0 to 70 and Emergency of 100				//adjust Brake Pipe between MAX and MIN Regulating value				pressure = MAX_REGULATING_VALVE - ((MAX_REGULATING_VALVE - MIN_REGULATING_VALVE) / 70) * step;				if (step == 100) {					gaugeDual.setNeedle(0);					eqPressure = MIN_REGULATING_VALVE;				} else if (bvic.isOpen() && (step > 0 && step < 100) && gaugeDual.getNeedleValue() < MIN_REGULATING_VALVE) {					gaugeDual.setNeedle(MIN_REGULATING_VALVE);					previousBPPressure = pressure;					eqPressure = MIN_REGULATING_VALVE;				} else if (bvic.isOpen() && (step == 0 || pressure < previousBPPressure)) {					gaugeDual.setNeedle(pressure);					previousBPPressure = pressure;					eqPressure = pressure;				}			} else {				if (step == 10) {					gaugeDual.setNeedle(0);				} else if (bvic.isOpen()) {					if (step == 0) {						eqPressure = MAX_REGULATING_VALVE;					}					gaugeDual.setNeedle(eqPressure);				}				pressure = gaugeDual.getNeedleValue();			}			if (activeSimulation) {				switch (activeSimulation) {					case tripleValve :						if (gaugeDual.getNeedleValue() == 0) {							tripleValve.slideIt("applied");						} else if (gaugeDual.getNeedleValue() == MAX_REGULATING_VALVE) {							tripleValve.slideIt("release");						} else if (onAir) {							tripleValve.slideIt("lap", gaugeBrakeCylinder.getNeedleValue() / 275);						}						break;					case brakeValve :						if (step == 0) {							position = "release";						} else if ((onAir && step == 100) || (!onAir && step == 10)) {							position = "emergency";						} else {							position = "applied";						}						brakeValve.animateIt(position, pressure, step, onAir, bvic.isOpen());						break;				}			}		}	}}