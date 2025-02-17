var AcModel = props.globals.getNode("sim/model/f-14b");
var SwCoolOffLight   = AcModel.getNode("controls/armament/acm-panel-lights/sw-cool-off-light");
var MslPrepOffLight  = AcModel.getNode("controls/armament/acm-panel-lights/msl-prep-off-light");
var StickSelector    = AcModel.getNode("controls/armament/stick-selector");
var ArmSwitch        = AcModel.getNode("controls/armament/master-arm-switch");
var ArmLever         = AcModel.getNode("controls/armament/master-arm-lever");
var GrSwitch         = AcModel.getNode("controls/armament/gun-rate-switch");
var SysRunning       = AcModel.getNode("systems/armament/system-running");
var GunRunning       = AcModel.getNode("systems/gun/running");
var GunCountAi       = props.globals.getNode("ai/submodels/submodel[3]/count");
var GunCount         = AcModel.getNode("systems/gun/rounds");
var GunReady         = AcModel.getNode("systems/gun/ready");
var GunStop          = AcModel.getNode("systems/gun/stop", 1);
var GunRateHighLight = AcModel.getNode("controls/armament/acm-panel-lights/gun-rate-high-light");


# AIM-9 stuff:
var SwCount    = AcModel.getNode("systems/armament/aim9/count");
var SWCoolOn   = AcModel.getNode("controls/armament/acm-panel-lights/sw-cool-on-light");
var SWCoolOff  = AcModel.getNode("controls/armament/acm-panel-lights/sw-cool-off-light");
var SwSoundVol = AcModel.getNode("systems/armament/aim9/sound-volume");
var aim9_seq   = [];
var aim9_count = 0;
Current_aim9   = nil;


aircraft.data.add( StickSelector, ArmLever, ArmSwitch );

var FALSE = 0;
var TRUE  = 1;





# Init
var weapons_init = func() {
	print("Initializing F-14B weapons system");
	ArmSwitch.setValue(1);
	ArmLever.setBoolValue(0);
	system_stop();
	SysRunning.setBoolValue(0);
	update_gun_ready();
	setlistener("controls/armament/trigger", func(Trig) {
		# Check selected weapon type and set the trigger listeners.
		var stick_s = StickSelector.getValue();
		if ( stick_s == 1 ) {
			update_gun_ready();
			if ( Trig.getBoolValue()) {
				GunStop.setBoolValue(0);
				fire_gun();
			} else {
				GunStop.setBoolValue(1);
			}
		} elsif ( (stick_s == 2 or stick_s == 3) and Trig.getBoolValue()) {
			release_aim9();
		}
	}, 0, 1);
}


# Main loop
var armament_update = func {
	# Trigered each 0.1 sec by instruments.nas main_loop() if Master Arm Engaged.

	# Check AIM-9 selected with armament panel switches 1 and 8.
	# Note in FAD light config, S1 and S8 also have AIM-9.
	var stick_s = StickSelector.getValue();
	aim9_seq = [];
	aim9_count = 0;
	if ( S0.get_selected() ) {
		# Check if at least one AIM-9 present on the pylons.
		# Build AIM-9 launch sequence. FIXME aim-9s in this order: 9-0-8-1.
		if ( S0.get_type() == "AIM-9" and stick_s == 2) {
			append(aim9_seq, S0);
			S0.set_display(1);
			aim9_count += 1;
		} elsif ( (S0.get_type() == "AIM-54" or S0.get_type() == "AIM-7")  and stick_s == 3) {
			append(aim9_seq, S0);
			S0.set_display(1);
			aim9_count += 1;
		} else {
			S0.set_display(0);
		}
		
	} else {
		S0.set_display(0);
	}
	if ( S1.get_selected() ) {
		if ( S1.get_type() == "AIM-9"  and stick_s == 2) {
			append(aim9_seq, S1);
			S1.set_display(1);
			aim9_count += 1;
		} elsif ( (S1.get_type() == "AIM-54" or S1.get_type() == "AIM-7") and stick_s == 3) {
			append(aim9_seq, S1);
			S1.set_display(1);
			aim9_count += 1;
		} else {
			S1.set_display(0);
		}
	} else {
		S1.set_display(0);
	}
	if ( S3.get_selected() ) {
		if ( (S3.get_type() == "AIM-54" or S3.get_type() == "AIM-7") and stick_s == 3) {
			append(aim9_seq, S3);
			S3.set_display(1);
			aim9_count += 1;
		} else {
			S3.set_display(0);
		}
	} else {
		S3.set_display(0);
	}
	if ( S4.get_selected() ) {
		if ( (S4.get_type() == "AIM-54" or S4.get_type() == "AIM-7") and stick_s == 3) {
			append(aim9_seq, S4);
			S4.set_display(1);
			aim9_count += 1;
		} else {
			S4.set_display(0);
		}
	} else {
		S4.set_display(0);
	}
	if ( S5.get_selected() ) {
		if ( (S5.get_type() == "AIM-54" or S5.get_type() == "AIM-7") and stick_s == 3) {
			append(aim9_seq, S5);
			S5.set_display(1);
			aim9_count += 1;
		} else {
			S5.set_display(0);
		}
	} else {
		S5.set_display(0);
	}
	if ( S6.get_selected() ) {
		if ( (S6.get_type() == "AIM-54" or S6.get_type() == "AIM-7") and stick_s == 3) {
			append(aim9_seq, S6);
			S6.set_display(1);
			aim9_count += 1;
		} else {
			S6.set_display(0);
		}
	} else {
		S6.set_display(0);
	}
	if ( S8.get_selected() ) {
		if ( S8.get_type() == "AIM-9"  and stick_s == 2) {
			append(aim9_seq, S8);
			S8.set_display(1);
			aim9_count += 1;
		} elsif ( (S8.get_type() == "AIM-54" or S8.get_type() == "AIM-7") and stick_s == 3) {
			append(aim9_seq, S8);
			S8.set_display(1);
			aim9_count += 1;
		} else {
			S8.set_display(0);
		}
	} else {
		S8.set_display(0);
	}
	if ( S9.get_selected() ) {
		if ( S9.get_type() == "AIM-9"  and stick_s == 2) {
			append(aim9_seq, S9);
			S9.set_display(1);
			aim9_count += 1;
		} elsif ( (S9.get_type() == "AIM-54" or S9.get_type() == "AIM-7") and stick_s == 3) {
			append(aim9_seq, S9);
			S9.set_display(1);
			aim9_count += 1;
		} else {
			S9.set_display(0);
		}
	} else {
		S9.set_display(0);
	}
	# Turn sidewinder cooling lights On/Off.
	if ( aim9_count > 0 ) {
		if (stick_s == 2) {
			SWCoolOn.setBoolValue(1);
			SWCoolOff.setBoolValue(0);
		}
	} else {
		SWCoolOn.setBoolValue(0);
		SWCoolOff.setBoolValue(1);
		# Turn Current_aim9.status to stand by.
		#set_status_current_aim9(-1);
	}
	SwCount.setValue(aim9_count);
	update_sw_ready();
	setCockpitLights();
}

var getDLZ = func {
    if (ArmSwitch.getValue() > 1 and Current_aim9 != nil) {
        return Current_aim9.getDLZ();
    }
}

var setCockpitLights = func {
	if (ArmSwitch.getValue() > 1 and Current_aim9 != nil and Current_aim9.status == 1) {
		setprop("sim/model/f-14b/systems/armament/lock-light", 1);
	} else {
		setprop("sim/model/f-14b/systems/armament/lock-light", 0);
	}
	var dlzArray = getDLZ();
	if (dlzArray == nil or size(dlzArray) == 0) {
	    setprop("sim/model/f-14b/systems/armament/launch-light", 0);
	} else {
		if (dlzArray[4] < dlzArray[1]) {
			setprop("sim/model/f-14b/systems/armament/launch-light", 1);
		} else {
			setprop("sim/model/f-14b/systems/armament/launch-light", 0);
		}
	}
}

var update_gun_ready = func() {
	var ready = 0;
	if ( ArmSwitch.getValue() == 2 and GunCount.getValue() > 0 ) {
		ready = 1;
	}
	GunReady.setBoolValue(ready);
}

var fire_gun = func {
	var grun   = GunRunning.getValue();
	var gready = GunReady.getBoolValue();
	var gstop  = GunStop.getBoolValue();
	if (gstop) {
		GunRunning.setBoolValue(0);
		return;
	}
	if (gready and !grun) {
		GunRunning.setBoolValue(1);
		grun = 1;
	}
	if (gready and grun) {
		var real_gcount = GunCountAi.getValue();
		var new_gcount = real_gcount*5;
		if (new_gcount < 5 ) {
			new_gcount = 0;
			GunRunning.setBoolValue(0);
			GunReady.setBoolValue(0);
			GunCount.setValue(new_gcount);
			return;
		}
		GunCount.setValue(new_gcount);
		settimer(fire_gun, 0.1);
	}
}

var update_sw_ready = func() {
	var sw_count = SwCount.getValue();
	if (sw_count != size(aim9_seq)) {
		print("Strange "~size(aim9_seq)~" pylons ready, but only counts "~sw_count);
		return;
	}
	
	#print("SIDEWINDER: sw_count - 1 = ", sw_count - 1);
	if (StickSelector.getValue() == 2 and ArmSwitch.getValue() == 2) {
		if (Current_aim9 != nil and Current_aim9.type != "AIM-9") {
			Current_aim9.status = -1;
			Current_aim9.del();
			Current_aim9 = nil;
		}
		if ((Current_aim9 == nil or Current_aim9.status == 2)  and sw_count > 0 ) {
			var pylon = aim9_seq[sw_count - 1];
			#print("FOX2 new !! ", pylon.index, " sw_count - 1 = ", sw_count - 1);
			Current_aim9 = armament.AIM.new(pylon.index, "AIM-9", "Sidewinder");
		} elsif (Current_aim9 != nil and Current_aim9.status == -1) {
			Current_aim9.status = 0;	
			Current_aim9.search();
		}
	} elsif (StickSelector.getValue() == 3 and ArmSwitch.getValue() == 2) {
		var pylon = nil;
		if (sw_count > 0 and size(aim9_seq) >= sw_count) {
			pylon = aim9_seq[sw_count - 1];
		}
		if (Current_aim9 != nil and (pylon == nil or (pylon != nil and Current_aim9.type != pylon.get_type()))) {
			Current_aim9.status = -1;
			Current_aim9.del();
			Current_aim9 = nil;
		}
		if ((Current_aim9 == nil or Current_aim9.status == 2)  and sw_count > 0 ) {
			var pylon = aim9_seq[sw_count - 1];
			var name = "Phoenix";
			if (pylon.get_type() == "AIM-7") {
				name = "Sparrow";
			}
			Current_aim9 = armament.AIM.new(pylon.index, pylon.get_type(), name);
		} elsif (Current_aim9 != nil and Current_aim9.status == -1) {
			Current_aim9.status = 0;	
			Current_aim9.search();	
		}
	} elsif (Current_aim9 != nil) {
		Current_aim9.status = -1;	
		SwSoundVol.setValue(0);
	}
}

var release_aim9 = func() {
	#print("RELEASE AIM-9 status: ", Current_aim9.status);
	if (Current_aim9 != nil) {
		if ( Current_aim9.status == 1 ) {
			var phrase = Current_aim9.brevity~" at: " ~ Current_aim9.Tgt.Callsign.getValue();
			if (getprop("payload/armament/msg")) {
				armament.defeatSpamFilter(phrase);
			} else {
				setprop("/sim/messages/atc", phrase);
			}
			Current_aim9.release();
			Current_aim9 = nil;
			# Set the pylon empty:
			var current_pylon = pop(aim9_seq);
			current_pylon.set_type("-");
			armament_update();
		}
	}
}

var set_status_current_aim9 = func(n) {
	if (Current_aim9 != nil) {
		Current_aim9.status = n;	
	}
}

# System start and stop.
# Timers for weapons system status lights.
var system_start = func {
	settimer (func { GunRateHighLight.setBoolValue(1); }, 0.3);
	update_gun_ready();
	SysRunning.setBoolValue(1);
	settimer (func { SwCoolOffLight.setBoolValue(1); }, 0.6);
	settimer (func { MslPrepOffLight.setBoolValue(1); }, 2);
	settimer (func {
		if (Current_aim9 != nil and StickSelector.getValue() == 2 and aim9_count > 0) {
			Current_aim9.status = 0;	
			Current_aim9.search();	
		}
	}, 2.5);
}
var system_stop = func {
	GunRateHighLight.setBoolValue(0);
	SysRunning.setBoolValue(0);
	foreach (var S; Station.list) {
		S.set_display(0); # initialize bcode (showing weapons set over MP).
	}
	if (Current_aim9 != nil) {
		set_status_current_aim9(-1);	
	}
	SwSoundVol.setValue(0);
	settimer (func { SwCoolOffLight.setBoolValue(0);SWCoolOn.setBoolValue(0); }, 0.6);
	settimer (func { MslPrepOffLight.setBoolValue(0); }, 1.2);
}


# Controls
var master_arm_lever_toggle = func {
	var master_arm_lever = ArmLever.getBoolValue(); # 0 = Closed, 1 = Open.
	var master_arm_switch = ArmSwitch.getValue();
	if ( master_arm_lever and master_arm_switch > 1 ) {
		ArmSwitch.setValue(1);
	}
	ArmLever.setBoolValue( ! master_arm_lever );
	if (master_arm_switch == 2) {
		ArmSwitch.setValue(1);
		system_stop();
	}
}

var master_arm_switch = func(a) {
	var master_arm_lever = ArmLever.getBoolValue();
	var master_arm_switch = ArmSwitch.getValue(); # 2 = On, 1 = Off, 0 = training (not operational yet).
	if (a == 1) {
		if (master_arm_switch == 0) {
			ArmSwitch.setValue(1);
		} elsif (master_arm_switch == 1 and master_arm_lever) {
			ArmSwitch.setValue(2);
			system_start();
		}
	} else {
		if (master_arm_switch == 1) {
			ArmSwitch.setDoubleValue(0);
		} elsif (master_arm_switch == 2) {
			ArmSwitch.setValue(1);
			system_stop();
		}
	}
	setCockpitLights();
}

var master_arm_cycle = func() {
	# Keyb. shorcut. Safety lever automaticly set. 
	var master_arm_lever = ArmLever.getBoolValue();
	var master_arm_switch = ArmSwitch.getValue();
	if (master_arm_switch == 0) {
		# Training --> Off.
		ArmSwitch.setValue(1);
		ArmLever.setBoolValue(0);
	} elsif (master_arm_switch == 1) {
		# Off --> 0n.
		ArmSwitch.setValue(2);
		ArmLever.setBoolValue(1);
		system_start();
		SysRunning.setBoolValue(1);
	} elsif (master_arm_switch == 2)  {
		# Training mode (not operational yet).
		ArmSwitch.setValue(0);
		ArmLever.setBoolValue(0);
		system_stop();
		SysRunning.setBoolValue(0);
	}
	setCockpitLights();
}

var arm_selector = func() {
	# Checks to do when rotating the wheel on the stick.
	update_gun_ready();
	var stick_s = StickSelector.getValue();
	if ( stick_s == 0 ) {
		SwSoundVol.setValue(0);
		set_status_current_aim9(-1);
	} elsif ( stick_s == 1 ) {
		SwSoundVol.setValue(0);	armament_update();

		set_status_current_aim9(-1);	
	} elsif ( stick_s == 2 ) {
		# AIM-9:
		if (Current_aim9 != nil and ArmSwitch.getValue() == 2 and aim9_count > 0) {
			Current_aim9.status = 0;	
			Current_aim9.search();	
		}
	} elsif ( stick_s == 3 ) {
		# AIM-9:
		if (Current_aim9 != nil and ArmSwitch.getValue() == 2 and aim9_count > 0) {
			Current_aim9.status = 0;	
			Current_aim9.search();	
		}
	} else {
		SwSoundVol.setValue(0);
		set_status_current_aim9(-1);	
	}
	setCockpitLights();
}

var station_selector = func(n, v) {
	# n = station number, v = up (-1) or down (1) or toggle (0) as there is two kinds of switches.
	if ( n == 3 or n == 4 or n == 5 or n == 6 ) {
		# Only up/neutral allowed.
		var selector = "sim/model/f-14b/controls/armament/station-selector[" ~ n ~ "]";
		var state = getprop(selector);
		if (state == -1000){
			# toggle value between 0 and -1
			state = -(-state - 1);
		}
		if (state != -1) {
			state = -1;
		} else {
			state = 0;
		}
		setprop(selector, state);
		if ( state == 0 ) {
			if ( n == 6 ) {
				f14.S6.set_selected(0);
			} elsif ( n == 3 ) {
				f14.S3.set_selected(0);
			} elsif ( n == 4 ) {
				f14.S4.set_selected(0);
			} elsif ( n == 5 ) {
				f14.S5.set_selected(0);
			}
		} elsif ( state == -1 ) {
			if ( n == 6 ) {
				f14.S6.set_selected(1);
			} elsif ( n == 3 ) {
				f14.S3.set_selected(1);
			} elsif ( n == 4 ) {
				f14.S4.set_selected(1);
			} elsif ( n == 5 ) {
				f14.S5.set_selected(1);
			}
		}
	}
	if ( n == 0 or n == 7 ) {
		# Only up/down allowed.
		var selector = "sim/model/f-14b/controls/armament/station-selector[" ~ n ~ "]";
		var state = getprop(selector);
		state += v;
		if ( state < -1 ) {
			state = -1;
		} elsif ( state > 1 ) {
			state = 1;
		}
		setprop(selector, state);
		if ( state == -1 ) {
			if ( n == 0 ) {
				f14.S0.set_selected(0);
				f14.S1.set_selected(1);
			} else {
				f14.S8.set_selected(1);
				f14.S9.set_selected(0);
			}
		} elsif ( state == 0 ) {
			if ( n == 0 ) {
				f14.S0.set_selected(0);
				f14.S1.set_selected(0);
			} else {
				f14.S8.set_selected(0);
				f14.S9.set_selected(0);
			}
		} elsif ( state == 1 ) {
			if ( n == 0 ) {
				f14.S0.set_selected(1);
				f14.S1.set_selected(0);
			} else {
				f14.S8.set_selected(0);
				f14.S9.set_selected(1);
			}
		}
	}
	armament_update();
}

var station_selector_cycle = func() {
	# Fast selector, selects with one keyb shorcut all AIM-9 or nothing.
	# Only to choices ATM.
	var s = 0;
	var p0 = getprop("sim/model/f-14b/controls/armament/station-selector[0]");
	var p7 = getprop("sim/model/f-14b/controls/armament/station-selector[7]");
	if ( p0 < 1 or p7 < 1 ) { s = 1; }
	setprop("sim/model/f-14b/controls/armament/station-selector[0]", s);
	setprop("sim/model/f-14b/controls/armament/station-selector[7]", s);
	f14.S0.set_selected(s);
	f14.S1.set_selected(0);
	f14.S8.set_selected(0);
	f14.S9.set_selected(s);	
	armament_update();
}

  ############ Cannon impact messages #####################

var last_impact = 0;

var hit_count = 0;

var impact_listener = func {
  if (awg_9.nearest_u != nil and (getprop("sim/time/elapsed-sec")-last_impact) > 1) {
    var ballistic_name = props.globals.getNode("/ai/models/model-impact3",1).getValue();
    var ballistic = props.globals.getNode(ballistic_name, 0);
    if (ballistic != nil and ballistic.getName() != "munition") {
      var typeNode = ballistic.getNode("impact/type");
      if (typeNode != nil and typeNode.getValue() != "terrain") {
        var lat = ballistic.getNode("impact/latitude-deg").getValue();
        var lon = ballistic.getNode("impact/longitude-deg").getValue();
        var impactPos = geo.Coord.new().set_latlon(lat, lon);

        #var track = awg_9.nearest_u.propNode;

        #var x = track.getNode("position/global-x").getValue();
        #var y = track.getNode("position/global-y").getValue();
        #var z = track.getNode("position/global-z").getValue();
        var selectionPos = awg_9.nearest_u.get_Coord();

        var distance = impactPos.distance_to(selectionPos);
        if (distance < 125) {
          last_impact = getprop("sim/time/elapsed-sec");
          var phrase =  ballistic.getNode("name").getValue() ~ " hit: " ~ awg_9.nearest_u.Callsign.getValue();
          if (getprop("payload/armament/msg")) {
            armament.defeatSpamFilter(phrase);
                  #hit_count = hit_count + 1;
          } else {
            setprop("/sim/messages/atc", phrase);
          }
        }
      }
    }
  }
}

# setup impact listener
setlistener("/ai/models/model-impact3", impact_listener, 0, 0);

var flareCount = -1;
var flareStart = -1;

var flareLoop = func {
  # Flare release
  if (getprop("ai/submodels/submodel[4]/flare-release-snd") == nil) {
    setprop("ai/submodels/submodel[4]/flare-release-snd", FALSE);
    setprop("ai/submodels/submodel[4]/flare-release-out-snd", FALSE);
  }
  var flareOn = getprop("ai/submodels/submodel[4]/flare-release-cmd");
  if (flareOn == TRUE and getprop("ai/submodels/submodel[4]/flare-release") == FALSE
      and getprop("ai/submodels/submodel[4]/flare-release-out-snd") == FALSE
      and getprop("ai/submodels/submodel[4]/flare-release-snd") == FALSE) {
    flareCount = getprop("ai/submodels/submodel[4]/count");
    flareStart = getprop("sim/time/elapsed-sec");
    setprop("ai/submodels/submodel[4]/flare-release-cmd", FALSE);
    if (flareCount > 0) {
      # release a flare
      setprop("ai/submodels/submodel[4]/flare-release-snd", TRUE);
      setprop("ai/submodels/submodel[4]/flare-release", TRUE);
      setprop("rotors/main/blade[3]/flap-deg", flareStart);
      setprop("rotors/main/blade[3]/position-deg", flareStart);
    } else {
      # play the sound for out of flares
      setprop("ai/submodels/submodel[4]/flare-release-out-snd", TRUE);
    }
  }
  if (getprop("ai/submodels/submodel[4]/flare-release-snd") == TRUE and (flareStart + 1) < getprop("sim/time/elapsed-sec")) {
    setprop("ai/submodels/submodel[4]/flare-release-snd", FALSE);
    setprop("rotors/main/blade[3]/flap-deg", 0);
    setprop("rotors/main/blade[3]/position-deg", 0);
  }
  if (getprop("ai/submodels/submodel[4]/flare-release-out-snd") == TRUE and (flareStart + 1) < getprop("sim/time/elapsed-sec")) {
    setprop("ai/submodels/submodel[4]/flare-release-out-snd", FALSE);
  }
  if (flareCount > getprop("ai/submodels/submodel[4]/count")) {
    # A flare was released in last loop, we stop releasing flares, so user have to press button again to release new.
    setprop("ai/submodels/submodel[4]/flare-release", FALSE);
    flareCount = -1;
  }
  settimer(flareLoop, 0.1);
};

flareLoop();