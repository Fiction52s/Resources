function SpriteCount()
	--return 1
	return 1
	
	--player is first
	--2nd is used for speed ball?
	--2nd is used for the combo fire?
end

function BodyType()
        return true, 2
		
		--fixed angle true or false,
        --static body: 0
        --kinematic body: 1
        --dynamic body : 2
end
 
function Init()
		
		power_boosterUpgrade = false
		power_gravitySwitch = false
		power_timeSlow = false
		power_berserkMode = false
		power_spacialTether = false
		power_speedBall = false
		
	
		power_boosterUpgrade = stage:HasPlayerPower( "boosterUpgrade" )
		power_spacialTether = stage:HasPlayerPower( "spacialTether" )
		power_gravitySwitch = stage:HasPlayerPower( "gravitySwitch" )
		
		power_gravitySwitch = true
	
        --note: 1 is the first index in Lua, not 0
        maxHealth = 500
        actor.health = maxHealth
		
		player = stage.player

		
		reflector = false
		accel = .8
	   
        --ground--
		killed = false
        grounded = false
        lastGrounded = false
        rcCount = 0
        rcNormal = ACTOR:b2Vec2()
        rcNormal.x = 0
        rcNormal.y = 0
        rcPoint = ACTOR:b2Vec2()
        rcPoint.x = 0
        rcPoint.y = 0
        rcFraction = 0
		rampSlopeAdjust = false
		
		hitlagVel = ACTOR:b2Vec2()
		hitlagVel.x = 0
		hitlagVel.y = 0
		hitlagVelSet = false
		
        oldGroundNormal = ACTOR:b2Vec2()
       
        specialVel = ACTOR:b2Vec2()
        specialVel.x = 0
        specialVel.y = 0
       
        carryVel = ACTOR:b2Vec2()
        carryVel.x = 0
        carryVel.y = 0
       
        specialAcc = ACTOR:b2Vec2()
        specialAcc.x = 0
        specialAcc.y = 0
       
		airControlLock = 0
	   
        groundlockActor = nil
        wallStop = false
       
        groundNormal = ACTOR:b2Vec2()
        groundNormal.x = 0
        groundNormal.y = 0
        groundControlSpeed = 1
        groundMaxControlSpeed = 9
        trueGrounded = false
        slopeSlow = false
        slopeAccel = false
       
        --air--
		forcedAirCounter = 0
        canInterruptJump = false
        grav = 2
        airControlSpeed = 1.5
        airSlowSpeed = .2
        airMaxControlSpeed = 7
        extraVel = 8 --the velocity you maintain when you let go of jump during your first jump
        framesInAir = 0
        --minFallY = -1
        actorRightWallJump = false
        actorLeftWallJump = false
        
	   
        --other--
        lastAction = nil
        touchingRightWall = false
        touchingLeftWall = false
        wallThreshold = .9
        maxFallVelocity = 60--84--40 --considering raising this because it looks weird at fast horizontal speeds
        maxVelocity = ACTOR:b2Vec2()
        maxVelocity.x = 60--84--40
        maxVelocity.y = 60--84
        prevPosition = ACTOR:b2Vec2()
        prevPosition.x = actor:GetPosition().x
        prevPosition.y = actor:GetPosition().y
        angle = 0
        collisionPoint1 = ACTOR:b2Vec2()
        collisionPoint1.x = -1
        collisionPoint1.y = -1
        collisionPoint2 = ACTOR:b2Vec2()
        collisionPoint2.x = -1
        collisionPoint2.y = -1
        prevVelocity = ACTOR:b2Vec2()
        prevVelocity.x = 0
        prevVelocity.y = 0
        actionChanged = false
        playerWidth = .25
        playerHeight = .75
        centerOffsetX = 0
       
        hitlagFrames = 0
        invincibilityFrames = 0
		
		dropThrough = false --so you dont go into the slide animation when you drop through
       
        --move specific/initialize animations--
       -- jog = actor:TileSetIndex( "jog.png" )
		--runSet = actor:TileSetIndex( "run.png" )
        jumpSet = actor:TileSetIndex( "jump.png" )
        --jogSet2 = actor:TileSetIndex( "jog2.png" )
        --dashSet = actor:TileSetIndex( "dash.png" )
		dashSet = actor:TileSetIndex( "dash2.png" )
        standSet = actor:TileSetIndex( "stand.png" )
        doubleJumpSet = actor:TileSetIndex( "doublejump.png" )
		hrunSet = actor:TileSetIndex( "hrun.png" )
		wallClingSet = actor:TileSetIndex( "wallcling.png" )
		walljumpSet = actor:TileSetIndex( "walljump.png" )
		walljumpstartSet = actor:TileSetIndex( "walljumpstart.png" )
		fairSet = actor:TileSetIndex( "fair.png" )
		airDashSet = actor:TileSetIndex( "airdash.png" )
        groundComboSet = actor:TileSetIndex( "groundcombo.png" )
		uairSet = actor:TileSetIndex( "uair.png" )
		dairSet = actor:TileSetIndex( "dair.png" )
		runningAttackSet = actor:TileSetIndex( "runningattack.png" )
		harrison3hitSet = actor:TileSetIndex( "harrison3hit.png" )
		speedBallSet = actor:TileSetIndex( "speedball.png" )
		greenRunSet = actor:TileSetIndex( "greenrun.png" )
		
		--actor:SetColor( 255,255,255,50 )
		
		
		hitstun = {}
        for i = 1, 20 do
			hitstun[i] = {doubleJumpSet, 2 }
        end
		---------------------
		--**power actions**--
		---------------------
		speedBall = {}
		for i = 1, 2 do
			--speedBall[i] = { dashSet, 13 }
			speedBall[i] = { speedBallSet, 0 }
		end
		
		maxAirDashFrames = 20--17
        airDash = {}
        for i = 1, maxAirDashFrames do
			if i <= 2 then
				airDash[i] = {airDashSet, 0}
			elseif i <= 5 then
				airDash[i] = {airDashSet, 1 }
			else
				airDash[i] = {airDashSet, 2}
			end	
        end
        hasAirDash = true
        airDashSpeed = 17
        airDashingRight = true
		
		airDashToFall = {}
		for i = 1, 5 * 2 do
			airDashToFall[i] = {airDashSet, (i - 1) / 2 + 3 }
		end
		
		gravitySlash = {}
        for i = 1, 24 do
			gravitySlash[i] = { doubleJumpSet, 10 }
        end
		gravitySlashSpeedFactor = 18
        gravitySlashRateX = 1
        gravitySlashRateY = 1
        hasGravitySlash = false
        endGravitySlash = false
        gravityReverseLimit = 60 * 3
        gravityReverseCounter = 0
		
		---------------------
		--**ground attacks**--
		---------------------
		
		runningAttack = {}
		for i = 1, 10 * 2 do
			runningAttack[i] = { runningAttackSet, (i - 1)/2 }
		end
		
		groundComboAttack1 = {}
        for i = 1, 18 do
		--for i = 1, 15 do
			groundComboAttack1[i] = {harrison3hitSet, ( i - 1 ) }
        end
		gca1CancelFrame = 18
		
		groundComboAttack2 = {}
        --for i = 1, 25 do
		for i = 1, 15 * 2 do
			groundComboAttack2[i] = {harrison3hitSet, (i-1) / 2 + 16}
        end
		groundComboAttack2Buffered = false
		gca2CancelFrame = 30
		
		groundComboAttack3 = {}
        for i = 1, 12 * 2 do
			groundComboAttack3[i] = {harrison3hitSet,(i-1) / 2 + 30 }
        end
		groundComboAttack3Buffered = false
		
		downGroundAttack = {}
		for i = 1, 10 do
			downGroundAttack[i] = {doubleJumpSet, 20 }
        end
		
		upGroundAttack = {}
		for i = 1, 10 do
			upGroundAttack[i] = {doubleJumpSet, 20 }
        end
		
		dashAttack = {}
		for i = 1, 10 do
			dashAttack[i] = { dashSet, 4 }
		end
		
		---------------------
		--**ground movement**--
		---------------------
		
		slide = {}
		for i = 1, 5 do
			slide[i] = { dashSet, 13 }
		end
		slideSlowFactor = 5
		slideFriction = .15
		slideLandFriction = .3
		slideGrav = .8
		
		standToRun = {}
		for i = 1, 2 * 3 do
			standToRun[i] = { hrunSet, (i - 1) / 3 }
		end
		--for i = 9, 14 do
		--	standToRun[i] = { runSet, 4 }
		--end
		
		run = {}
        for i = 1 * 3, 12 * 3 do
           run[i-2] = { greenRunSet, (i - 1) / 3 }
        end
		
		for i = 3 * 3, 14 * 3 do
      --     run[i - 8] = { hrunSet, (i - 1) / 3 }
        end
		
		stand = {}
        for i = 1, 3 * 35 do
			stand[i] = { standSet, ( i - 1 ) / 3 }
        end
		
		jump = {}
        for i = 1, 5 do
			jump[i] = { jumpSet, i - 1 }
        end
        jumpStrength = 30.5
		
		landing = {}
        for i = 6, 7 do
			landing[i] = { jumpSet, i - 1 }
        end
		
		dash = {}
        for i = 1, 4 * 1 do
			dash[i] = { dashSet, (i - 1)/1 }
        end
        for i = 5, 30 do
        dash[i] = { dashSet, 4 }
        end
        dashSpeed = 14
        maxDashFrames = 30
		framesDashing = 0
       
        dashToStand = {}
        for i = 1,13 do
			dashToStand[i] = { dashSet, 4 + i }
        end
		
		onSteepRightSlope = false
		onSteepLeftSlope = false
		forcedSlide = {}
		for i = 1, 2 do
			forcedSlide[i] = { dashSet, 4 }
		end
		
		slopeClimb = {}
		
		---------------------
		--**aerial movement**--
		---------------------
		
		wallCling = {}
		wallCling[1] = { wallClingSet, 0 }
		
		doubleJump = {}
        for i = 1, 1 * 39 do
			doubleJump[i] = { doubleJumpSet, ( i - 1 ) / 1}
        end
        doubleJumpStrength = 26--25
        hasDoubleJump = true
		
		wallPress = {}
        for i = 1, 3 * 35 do
			wallPress[i] = { standSet, ( i - 1 ) / 3 }
        end
		
		wallJumpFrames = 15
        wallJump = {}
        for i = 1, wallJumpFrames * 2 do
			if i <= 2 * 2 then
				wallJump[i] = { walljumpstartSet, (i - 1) / 2 }
			else
				wallJump[i] = { walljumpSet, (i - 5) / 2}
			end
			
        end
        wallJumpStrengthY = 28
        wallJumpStrengthX = 11
		
		fastFall = {}
        for i = 1, 5 do
			fastFall[i] = { doubleJumpSet, 15 }
        end
        fastFallBoost = 40
        fastFallMax = 40
		
		---------------------
		--**aerial attacks**--
		---------------------
		
		forwardAirAttack = {}
        for i = 1, 5 do
			forwardAirAttack[i] = {fairSet, (i-1) }
        end
		
		for i = 1, 11 * 2 do
			forwardAirAttack[i + 5] = { fairSet, ((i - 1) / 2 + 5) }
		end
		
		for i = 1, 8 do
			forwardAirAttack[i + 27] = {fairSet, (i-1) + 16 }
		end
		
		upAirAttack = {}
		for i = 1, 16 do
			upAirAttack[i] = {uairSet, (i-1)}
        end
		for i = 17, 40 do
			upAirAttack[i] = {jumpSet, 3}
		end
		
		downAirAttack = {}
		for i = 1, 8 do
			downAirAttack[i] = {dairSet, (i-1) }
		end
		for i = 1, 13*1 do
			downAirAttack[i+8] = {dairSet, (i-1)/1 + 8 }
		end
		------------------------------------------------------------------------
       
        --contact types--
        bodyTypes = {Normal = 1}
        bodyStrings = {"Normal"}
        hitboxTypes = {Heal = 1, Slash = 2}
        hitboxStrings = {"Heal", "Slash"}
       
        --init state
       
        action = stand
        prevAction = nil
        prevFrame = 1
        frame = 1
       
        actor:SetVelocity( 0, 0 )
        --this will eventually be replaced with createBoxes ONLY IN UPDATE for each action, if the box changes during a dash or w.e.
        actor:ClearHurtboxes()
        actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, 0, 0, .5, 1.5, 0 )
        actor:ClearHurtboxes()
        actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, 0, 0, .5, 1.5, 0 )
       
        actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .5, 1.5, 0 )
       
        actor:CreateBox( bodyTypes.Normal, Layer_PlayerEventCollision, 0, 0, .5, 1.5, 0 )
        actor:SetFriction( 0 )
       
        --this is for resetting the position later for easier testing
        originalPos = ACTOR:b2Vec2()
        originalPos.x = actor:GetPosition().x
        originalPos.y = actor:GetPosition().y
       
      -- actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .5, .5, 0 )
        stage:SetCameraPosition( actor:GetPosition().x, actor:GetPosition().y )
		
		
		actor:SetSpriteEnabled( 0, true )
		
		tethered = false
		
		leftTetherThing = false
		rightTetherThing = false
		
		lastRadians = 0
		
		rightStickDirTimerMax = 90
		rightStickDirTimer = 0
		
end
 
function GetAttackType( i )
        return hitTypes[i]
end
 
function Heal( otherActor )
        print( "I am healing you" )
end
 
function Slash( otherActor )
        print( "slashing" )
end
 
function ActionEnded()
        if frame > #action then
               
                actor:ClearActorsAttacked()
                if action == wallJump then
						
                        SetAction( jump )
                        actionChanged = false
                        frame = 3
                elseif action == airDash then						
						SetAction( airDashToFall )
						frame = 1
						actionChanged = false
                       
                        --actionChanged = false
                        if airDashingRight then
                                actor:SetVelocity( 0, 0 )
                        else
                                actor:SetVelocity( 0, 0 )
                        --      actor:SetVelocity( -airMaxControlSpeed, 0 )
                        end    
				elseif action == airDashToFall then
						SetAction( jump )
						frame = 4
						actionChanged = false
                elseif action == jump then
                        frame = 4
                        --actionChanged = true
                elseif action == dash then
                        --frame = 7
                        SetAction( dashToStand )
                        frame = 1
                        actionChanged = false
                       
                        if actor:GetVelocity().y <= 0 then
                                --actor:SetVelocity( 0, 0 )
                        end
                        --actionChanged = true
                --      print( "---------------------------------------------------------" )
                elseif action == doubleJump then
                        SetAction( jump )
						actionChanged = false
                        frame = 3
                elseif action == stand then
                        frame = 1
                elseif action == fastFall then
                        --frame = 14
						SetAction( jump )
						actionChanged = false
						frame = 4
                elseif action == gravitySlash then
                        SetAction( nil )
						actionChanged = false
                        frame = 0
                        actor:SetVelocity( 0, actor:GetVelocity().y )
				elseif action == dashToStand then
						SetAction( stand )
						frame = 1
						actionChanged = false
				elseif action == standToRun then
						SetAction( run )
						actionChanged = false
						frame = 1 
				elseif action == wallCling then
						frame = 1
				elseif action == slide then
						frame = 5
				elseif action == runningAttack then
						print( "set to run" )
						SetAction( run )
						frame = 1
						actionChanged = false
				elseif action == speedBall then
						frame = 1
				elseif action == forcedSlide then
						frame = 1
                else
                        SetAction( nil )
						actionChanged = false
						frame = 0
                        frame = 0 --not sure if this ever comes into play
                end
        end
       
end
 
function CancelAction()
        actor:ClearActorsAttacked()
        --here you would cancel any effects created by actions which are being canceled
end
 
function ChooseAction()

        if action == hitstun then
            actionChanged = true
        end
		
		local leftState = player:GetTetherState( true )
		local rightState = player:GetTetherState( false )
		
		
		if currentInput.leftStickMagnitude > .5 and rightStickDirTimer == 0 then
			lastRadians = currentInput.leftStickRadians + math.pi / 2
			player:SetStoredRadians( lastRadians )
		end
		
		if currentInput.rightStickMagnitude > .8 and (rightState == "dormant" or leftState == "dormant") then
			rightStickDirTimer = rightStickDirTimerMax
			player:SetTetherAim( true )
			print( "on" )
			lastRadians = currentInput.rightStickRadians + math.pi / 2
			player:SetStoredRadians( lastRadians )
		end
		
		
		
		
		if currentInput.Y and not prevInput.Y and action ~= speedBall and (action == stand or action == run or action == jump or action == doubleJump 
		or  action == wallJump or action == dash or action == nil or action == standToRun or action == slide or action == fastFall or action == wallCling ) then
			
			SetAction( speedBall )
			frame = 1
			--grounded = false
			--player:SetSpeedBallEnabled( true )
			actor:ClearPhysicsboxes()
			actor:CreateCircle( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .75 )
			--actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, 1.1, 1.1, 0 )
			--actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .5, 1.5, 0 )
			--actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, 1.5, .5, 0 )
			
			
		end
		
		if currentInput.Y and not prevInput.Y and action == speedBall and not actionChanged then						
			SetAction( jump )
			frame = 3
			grounded = false
			actor:ClearPhysicsboxes()
			actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .5, 1.5, 0 )
				--print( "player vel upon disabling: " .. player:GetSpeedBallVel().x .. ", " .. player:GetSpeedBallVel().y )
			   -- actor:SetVelocity( player:GetSpeedBallVel().x, player:GetSpeedBallVel().y )
				
				--print( "player vel upon disabling: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
				--player:SetSpeedBallEnabled( false )
				
			
		--if action == speedBall then
			
		--end
				--actor:ClearPhysicsboxes()
			
		end
		
		
		
		
		
		if currentInput.rightShoulder and rightState == "locked" then
		--	player:ShrinkTether( .5, false )
		elseif currentInput.leftShoulder and leftState == "locked" then
		--	player:ShrinkTether( .5, true )
		end
		
		local triggerThresh = 100
		
		if currentInput.leftTrigger > triggerThresh then
			if prevInput.leftTrigger <= triggerThresh and leftState == "dormant" then
				local vel = ACTOR:b2Vec2()
				local shotSpeed = 70
				vel.x = math.sin( lastRadians ) * shotSpeed
				vel.y = math.cos( lastRadians ) * shotSpeed
				
				player:TetherShot( shotSpeed, true )
				rightStickDirTimer = 0
			end
		elseif currentInput.leftTrigger <= triggerThresh and leftState == "locked" then
			player:ReleaseTether( true )
		end
		
		if currentInput.rightTrigger > triggerThresh and prevInput.rightTrigger <= triggerThresh and rightState == "dormant" then			
			local vel = ACTOR:b2Vec2()
			local shotSpeed = 70
			vel.x = math.sin( lastRadians ) * shotSpeed
			vel.y = math.cos( lastRadians ) * shotSpeed
			player:TetherShot( shotSpeed, false )
			rightStickDirTimer = 0
		elseif currentInput.rightTrigger <= triggerThresh and rightState == "locked" then
			player:ReleaseTether( false )
		end
		
		
		
		if (currentInput.rightTrigger > triggerThresh or currentInput.leftTrigger > triggerThresh) then
			
			local leftState = player:GetTetherState( true )
			local rightState = player:GetTetherState( false )
			
			if currentInput.rightTrigger > triggerThresh and rightState == "anchored" then
				player:LockTether( false )
			end
			
			if currentInput.leftTrigger > triggerThresh and leftState == "anchored" then
				player:LockTether( true )
			end
			
			if rightState == "locked" and currentInput.rightTrigger > triggerThresh then

				--player:LockTether( false )
				
				if leftState == "locked" and currentInput.leftTrigger > triggerThresh then
					player:ShrinkTether( .25, false )
					player:ShrinkTether( .25, true )
					--player:GrowTether( 1, true )
				else
					player:ShrinkTether( 1, false )
				end
					
			end
			
			if leftState == "locked" and currentInput.leftTrigger > triggerThresh then				
				--player:LockTether( true )
				
				if currentInput.rightTrigger > triggerThresh and rightState == "locked" then
					player:ShrinkTether( .25, true )
					player:ShrinkTether( .25, false )
				--	player:GrowTether( 1, false )
				else
					player:ShrinkTether( 1, true )
				end
				
			end
		end		
		
		if rightStickDirTimer > 0 then
			rightStickDirTimer = rightStickDirTimer - 1
		else
			player:SetTetherAim( false )
		end
		
		
		if currentInput.leftShoulder and not prevInput.leftShoulder and not stage.cloneWorld then
			stage.cloneWorldStart = true
		end
		
		if currentInput.leftShoulder and not prevInput.leftShoulder and stage.cloneWorld then
			stage.cloneWorldExtra = true
		end
		
		if currentInput:AltLeft() and not prevInput:AltLeft() and stage.cloneWorld then
		--	stage.cloneWorldRevert = true
		end
		
		if currentInput.rightShoulder and not prevInput.rightShoulder and stage.cloneWorld then
			stage.cloneWorldCollapse = true
		end
		
		if not stage.cloneWorld and currentInput.rightShoulder and not prevInput.rightShoulder then
			--print( "creating the time wave" )
			local vel = ACTOR:b2Vec2()
			vel.x = 0
			vel.y = 0
			stage:CreateActor( "timewave", actor:GetPosition(), vel, actor:IsFacingRight(), false, 0, actor )
			--print( "creating the time wave" )
			--collapse
			--stage.cloneWorldCollapse = true
		end

        if not actionChanged and currentInput.X and not prevInput.X and grounded and action ~= speedBall then
			if (action == stand or action == nil or action == dashToStand or action == slide ) then
				if currentInput:Up() and not ( currentInput:Left() or currentInput:Right() ) then
					SetAction( upGroundAttack )
				elseif currentInput:Down() and not ( currentInput:Left() or currentInput:Right() ) then
					SetAction( downGroundAttack )
				else
					SetAction( groundComboAttack1 )
					groundComboAttack2Buffered = false
					groundComboAttack3Buffered = false
				end
				frame = 1
			elseif action == dash then
				SetAction( dashAttack )
				frame = 1
			elseif action == run or action == standToRun then
				SetAction( runningAttack )
				frame = 1
			end
			
        end
		
		
		if action == groundComboAttack1 and frame == gca1CancelFrame and groundComboAttack2Buffered then
			SetAction( groundComboAttack2 )
			frame = 1
		end
		
		if action == groundComboAttack2 and frame == gca2CancelFrame and groundComboAttack3Buffered then
			SetAction( groundComboAttack3 )
			frame = 1
		end
       
        if not actionChanged and currentInput.X and not prevInput.X and (action == jump or action == doubleJump or ( action == wallJump --[[and frame > 4--]] ) ) and action ~= speedBall then
				airControlLock = 10 - frame
				if currentInput:Up() then
					SetAction( upAirAttack )
					frame = 1
				elseif currentInput:Down() then
					SetAction( downAirAttack )
					frame = 1
                else
                    SetAction( forwardAirAttack )
                    frame = 1
                end
        end
 
        if not actionChanged and not grounded and action ~= speedBall then
                if not reflector and  touchingRightWall and currentInput:Left() and not prevInput:Left() and not currentInput:Down() and ( action ~= gravitySlash or ( action == gravitySlash and frame > 18 ) ) then--and action ~= airDash then
                        SetAction( wallJump )
                        frame = 1
                elseif not reflector and touchingLeftWall and currentInput:Right() and not prevInput:Right() and not currentInput:Down() and ( action ~= gravitySlash or ( action == gravitySlash and frame > 18 ) ) then-- and action ~= airDash then
                        SetAction( wallJump )
                        frame = 1
				elseif action == wallCling and currentInput.A and not prevInput.A then
						--SetAction( wallJump )
						--frame = 1
                elseif not reflector and action ~= fastFall and action ~= gravitySlash and currentInput.A and not prevInput.A
                        and (( actorRightWallJump and currentInput:Left() ) or ( actorLeftWallJump and currentInput:Right() )) then
                --      and otherActor:Message( actor, "walljump", 0 ) ~= 0 and action == jump or action == doubleJump or action == wallJump then then
                        if actorRightWallJump and currentInput:Left() then
                                actorLeftWallJump = false
                        else
                                actorRightWallJump = false
                        end
                        SetAction( wallJump )
                        frame = 1
                end
                if action ~= jump and action ~= doubleJump and action ~= wallJump and action ~= airDash and action ~= forwardAirAttack and action ~= upAirAttack and action ~= downAirAttack and action ~= fastFall
                        and action ~= gravitySlash and action ~= airDashToFall and ( action ~= forcedSlide or not ( onSteepLeftSlope or onSteepRightSlope) ) then
                        SetAction( jump )
                        actionChanged = false
                        frame = 3
						
                        --^^eventually change this to falling
                       
                end
        end
 
        if not actionChanged then
                if currentInput.A and not prevInput.A and grounded and ( action == stand or action == dashToStand or action == run or action == standToRun or action == nil or action == dash or action == slide  ) then
                        --if player is rising, give him extra jump height. If he isn't rising, jump as usual
                        --if action == stand then
               
                        --      actor:SetVelocity( 0, actor:GetVelocity().y )
                        --end
                        SetAction( jump )
                        
                        frame = 1
                        grounded = false
						
						local pos = ACTOR:b2Vec2()
						pos.x = actor:GetPosition().x
						pos.y = actor:GetPosition().y + .5
						
						local vel = ACTOR:b2Vec2()
						vel.x = 0
						vel.y = 0
						
						if not actor:IsReversed() then
						
						stage:CreateActor( "landdust", pos, vel, actor:IsFacingRight(), false, 0, actor )
						
						end
                --      print( "jump" )
                elseif currentInput.A and not prevInput.A and (action == jump or action == wallJump or action == airDashToFall or (action == airDash and frame < 10 ) or action == doubleJump
                                or ( action == forwardAirAttack and frame > 7 ) or ( action == upAirAttack and frame > 7 ) or ( action == downAirAttack and frame > 7 ) or ( action == gravitySlash and frame > 18 ) ) then
                        --double jump. Lock to either 0 or airMaxControlSpeed to allow double jumps to change momentum
                        if not grounded and hasDoubleJump then
                                SetAction( doubleJump )
                                frame = 1
								
								local pos = ACTOR:b2Vec2()
							pos.x = actor:GetPosition().x
							pos.y = actor:GetPosition().y + .5
							
							local vel = ACTOR:b2Vec2()
							vel.x = 0
							vel.y = 0
							
							stage:CreateActor( "landdust", pos, vel, actor:IsFacingRight(), false, 0, actor )
							
                        elseif grounded then
                                --to get rid of one frame super jump
                                --.7
                                --actor:SetVelocity( actor:GetVelocity().x * 1, actor:GetVelocity().y * .7 )
								--print( "before this:
                                actor:SetVelocity( prevVelocity.x, prevVelocity.x * -groundNormal.x / groundNormal.y )
                                SetAction( jump )
								
                                frame = 1
                                grounded = false
                                
                                if action == jump and not currentInput:Left() and not currentInput:Right() then
                                        actor:SetVelocity( 0, 0 )
                                end
                                --*remove this to bring back single frame boost jumping on slopes.
                                --actor:SetVelocity( actor:GetVelocity().x * .7, actor:GetVelocity().y * .7 )
                        end
                end
        end
       
        if not actionChanged then
                if action == stand or action == dashToStand or action == run or action == standToRun or action == nil or action == jump or action == doubleJump or action == forwardAirAttack or action == downAirAttack or action == upAirAttack
				or action == wallJump or action == slide or action == fastFall or action == forcedSlide then
                        if grounded and currentInput:Left() then
                                actor:FaceLeft()
                                if action ~= run and action ~= standToRun then
										if action == stand then
											SetAction( standToRun )
										else
											SetAction( run )
										end
                                        actionChanged = false
                                        frame = 1
                                end    
                        elseif grounded and currentInput:Right() then
                                actor:FaceRight()
                                if action ~= run and action ~= standToRun then
                                        if action == stand then
											SetAction( standToRun )
										else
											SetAction( run )
										end
                                        actionChanged = false
                                        frame = 1
                                end
						elseif grounded and currentInput:Down() and action ~= slide then
								SetAction( slide )
								frame = 1
								
                        end
                end
        end
        
		
		--this is where the in place bug is ^^
		if not actionChanged and currentInput:Down() and not ( currentInput:Left() or currentInput:Right() ) and ( action == run or action == nil 
			or action == standToRun ) then 
			SetAction( slide )
			frame = 1
		end
		
		--and not( currentInput:Left() or currentInput:Right() )
		power_boosterUpgrade = true
        if power_boosterUpgrade and not actionChanged and action ~= speedBall and action ~= forcedSlide then
                if currentInput.B and not prevInput.B and currentInput:Down() and not grounded and action ~= gravitySlash and action ~= fastFall then
					if action == forwardAirAttack or action == upAirAttack or action == downAirAttack then
						if actor:GetVelocity().y < 0 then
							actor:SetVelocity( actor:GetVelocity().x * 3 / 3, fastFallBoost )
						else
							actor:SetVelocity( actor:GetVelocity().x * 3 / 3, actor:GetVelocity().y + fastFallBoost )
						end
						actionChanged = true
					else
                        SetAction( fastFall )
                        frame = 1
					end
                end
        end
       
        if power_gravitySwitch and not actionChanged then
                if currentInput.B and not prevInput.B and currentInput:Up() and ( action ~= forwardAirAttack or ( action == forwardAirAttack and frame > 7 ) )
						and ( action ~= upAirAttack or ( action == upAirAttack and frame > 7 ) )
						and ( action ~= downAirAttack or ( action == downAirAttack and frame > 7 ) )
                        and action ~= groundComboAttack1 and action ~= groundComboAttack2 and action ~= groundComboAttack3 and action ~= upGroundAttack and action ~= downGroundAttack and action ~= dashAttack and action ~= fastFall and hasGravitySlash then
                                if currentInput:Right() then
                                        actor:FaceRight()
                                elseif currentInput:Left() then
                                        actor:FaceLeft()
                                end
                                --actor:SetVelocity( 0, 0 )
                                SetAction( gravitySlash )
                                frame = 1
                                grounded = false
                                hasGravitySlash = false
                                hasAirDash = false
								hasTether = false
                end
        end
       
        if not actionChanged and action ~= speedBall then
                if currentInput.B and not prevInput.B and grounded then
                        if action ~= dash and action ~= downGroundAttack and action ~= upGroundAttack and action ~= groundComboAttack1 and action ~= groundComboAttack2 and action ~= groundComboAttack3 then
							if action == run --[[or action == standToRun--]] then
								SetAction( dash )
								frame = 5
							else
                                SetAction( dash )
                                frame = 1
								
								
							end
                        end
                elseif action == dash and ( not currentInput.B or framesDashing >= maxDashFrames ) then
                        if (actor:GetVelocity().x > dashSpeed and currentInput:Right()) or ( actor:GetVelocity().x < -dashSpeed and currentInput:Left()) then
                                SetAction( run )
                        else
							if framesDashing < 10 then
							--	SetAction( stand )
								SetAction( dashToStand )
							else
                                SetAction( dashToStand )
							end
                        actionChanged = false
                        end
                       
                        frame = 1
                        framesDashing = 0

                elseif power_boosterUpgrade and not grounded and hasAirDash and currentInput.B and not prevInput.B and ( action == jump or action == doubleJump
                           or action == wallJump or ( action == forwardAirAttack and frame > 7 )  
						   or ( action == upAirAttack and frame > 7 )
						   or ( action == downAirAttack and frame > 7 ) ) and action ~= speedBall then
						    
                        SetAction( airDash )
                        frame = 1
                        hasAirDash = false
                        hasGravitySlash = false
                        if currentInput:Left() then
                                airDashingRight = false
                                actor:FaceLeft()
                        elseif currentInput:Right() then
                                airDashingRight = true
                                actor:FaceRight()
                        else
                                airDashingRight = actor:IsFacingRight()
                        end
                elseif not grounded and not currentInput.B and action == airDash then
                        --SetAction( jump )
						SetAction( airDashToFall )
						frame = 1
						actionChanged = false
                        --frame = 3
                       
                        if airDashingRight then
                                actor:SetVelocity( 0, 0 )
                                --actor:SetVelocity( airMaxControlSpeed, 0 )
                        else
                                actor:SetVelocity( 0, 0 )
                                --actor:SetVelocity( -airMaxControlSpeed, 0 )
                        end
                end
        end
		
		
       
        if grounded and not actionChanged and action ~= speedBall and ( (action == airDash and groundNormal.y ~= -1 ) or action == airDashToFall or action == nil or action == jump or action == doubleJump or action == forwardAirAttack or action == upAirAttack or action == downAirAttack or action == wallCling or action == wallJump
                or ( ( action == run or action == standToRun ) and not currentInput:Left() and not currentInput:Right() ) or action == fastFall or action == forcedSlide ) then
				
				SetAction( stand )
				frame = 1
        end
		
		if grounded and not actionChanged and action == slide and not currentInput:Down() then
			SetAction( stand )
			frame = 1
		end
		
		if not grounded then
			framesInAir = framesInAir + 1
        end
end
 
function HandleAction()
		
        actor:ClearHitboxes()
        actor:ClearDetectionboxes()
       
		
		if action == groundComboAttack1 or action == groundComboAttack2 or action == groundComboAttack3 then
			actor:SetSpriteOffset( 0, 1.5, -.4 )
		end
       
        if action == fastFall and frame == 1 then
                if actor:GetVelocity().y < 0 then
                        actor:SetVelocity( actor:GetVelocity().x * 2 / 3, fastFallBoost )
                else
                        actor:SetVelocity( actor:GetVelocity().x * 2 / 3, actor:GetVelocity().y + fastFallBoost )
                end
        end
		
		
       
		if reflector and ((not grounded and touchingRightWall and prevVelocity.x > 0) or ( not grounded and touchingLeftWall and prevVelocity.x < 0)) then

			actor:SetVelocity( -prevVelocity.x, actor:GetVelocity().y )
			
			if touchingRightWall then
				actor:FaceLeft()
			else
				actor:FaceRight()
			end
        end
		reflector = false
	   
        if action == gravitySlash then
                if frame == 1 then
                        if actor:IsFacingRight() or currentInput:Right() then
                                --actor:SetVelocity( gravitySlashRateX * (gravitySlashSpeedFactor - 1), -gravitySlashRateY )
								actor:SetVelocity( actor:GetVelocity().x, -gravitySlashRateY )
                        elseif not actor:IsFacingRight() or currentInput:Left() then
								actor:SetVelocity( actor:GetVelocity().x, -gravitySlashRateY )
                                --actor:SetVelocity( -gravitySlashRateX * (gravitySlashSpeedFactor - 1), -gravitySlashRateY )
                        end
                       
                elseif frame < 14 then
					if actor:IsFacingRight() then
                       -- actor:SetVelocity( gravitySlashRateX * ( gravitySlashSpeedFactor - frame ), -gravitySlashRateY * (frame + 3) )
                       actor:SetVelocity( actor:GetVelocity().x, -gravitySlashRateY * ( frame + 3 ) )
                        --actor:SetVelocity( actor:GetVelocity().x - gravitySlashRateX, actor:GetVelocity().y - gravitySlashRateY )
					else
						actor:SetVelocity( actor:GetVelocity().x, -gravitySlashRateY * ( frame + 3 ) )
                        --actor:SetVelocity( -gravitySlashRateX * ( gravitySlashSpeedFactor - frame ), -gravitySlashRateY * (frame + 3) )
                        --actor:SetVelocity( actor:GetVelocity().x + gravitySlashRateX, actor:GetVelocity().y - gravitySlashRateY )
					end
				elseif frame > 18 then
					actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + grav )
                end
				hasAirDash = false
                hasGravitySlash = false
				hasTether = false
                grounded = false
                angle = 0
				
				
        end
       
        if ( action == forwardAirAttack or action == upAirAttack or action == downAirAttack ) and lastAction == jump then
			if not currentInput.A and prevInput.A and actor:GetVelocity().y < -extraVel and not grounded and canInterruptJump then 
				actor:SetVelocity( actor:GetVelocity().x, -extraVel )
			end
        end
		

        if action == stand then
                actor:SetVelocity( 0, 0 )
		elseif action == dashToStand then
			actor:SetVelocity( actor:GetVelocity().x * 4/5, actor:GetVelocity().y * 4 / 5 )
        elseif action == jump then
			if frame == 1 then
				grounded = false    
				
				canInterruptJump = true
				if actor:GetVelocity().y < 0 then
					actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y * .8 - jumpStrength )
				else
					actor:SetVelocity( actor:GetVelocity().x, - jumpStrength )
				end
				if gravityReverseCounter > 0 then
					actor:SetVelocity( actor:GetVelocity().x, 0 )
				end
			else
				if angle == 0 then
					if actor:GetVelocity().x > 0 and actor:IsFacingRight() then
				--		angle = .05
					elseif actor:GetVelocity().x < 0 and not actor:IsFacingRight() then
					--	angle = -.05
					end
				end
		
				if not currentInput.A and prevInput.A and actor:GetVelocity().y < -extraVel and not grounded and canInterruptJump then
						actor:SetVelocity( actor:GetVelocity().x, -extraVel )
				end
				if actor:GetVelocity().y > maxFallVelocity - 10 then
						frame = 5
				elseif actor:GetVelocity().y >=0 then
						frame = 4
						canInterruptJump = false
				elseif actor:GetVelocity().y < 0 then
						frame = 3
				end
			end    
        elseif action == doubleJump then
			if frame == 1 then
				hasDoubleJump = false
				if currentInput:Left() then
					actor:SetVelocity( math.min( -airMaxControlSpeed, actor:GetVelocity().x ), -doubleJumpStrength )
				elseif currentInput:Right() then
					actor:SetVelocity( math.max( airMaxControlSpeed, actor:GetVelocity().x ), -doubleJumpStrength )
				else
					actor:SetVelocity( 0, -doubleJumpStrength )
				end
			end
        elseif action == wallJump then
			if frame == 1 then
				if touchingRightWall then
						actor:FaceLeft()
						actor:SetVelocity( -wallJumpStrengthX, -wallJumpStrengthY )
				elseif touchingLeftWall then
						actor:FaceRight()
						actor:SetVelocity( wallJumpStrengthX, -wallJumpStrengthY )
				elseif actorRightWallJump then
						actor:FaceLeft()
						actor:SetVelocity( -wallJumpStrengthX, -wallJumpStrengthY )
				elseif actorLeftWallJump then
						actor:FaceRight()
						actor:SetVelocity( wallJumpStrengthX, -wallJumpStrengthY )
				else
						print( "errorjump")
				end
			end
        elseif action == airDash then
			
			if frame == 1 then
				
				local pos = ACTOR:b2Vec2()
				local vel = ACTOR:b2Vec2()
				vel.x = 0
				vel.y = 0
				
				pos.x = actor:GetPosition().x

				if actor:IsReversed() then
					pos.y = actor:GetPosition().y - 0
				else
					pos.y = actor:GetPosition().y + 0
				end

				--stage:CreateActor( "airdashdust", pos, vel, actor:IsFacingRight(), actor:IsReversed(), angle/ math.pi, actor )
			end
		
			if frame == 3 or frame == 4 or frame == 5 or frame == 6 then
				
				if frame == 3 then
				
					actor:SetSpriteOffset( 0, 0, .5 )
					local xoff = .3
					local yoff = .5---.4
					if not actor:IsFacingRight() then
						xoff = -xoff
					end

					
					actor:ClearPhysicsboxes()
					
					actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, .1, .5, .5, 0 )
					if actor:IsFacingRight() then
						actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, .2, .3, 1, .4, 0 )
					else
						actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, -.2, .3, 1, .4, 0 )
					end
					actor:ClearHurtboxes()
					actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, xoff, yoff - .2, 1, .8, 0 )
				
				elseif frame == 4 then
					actor:ClearPhysicsboxes()
					
					actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, .1, .5, .5, 0 )
					if actor:IsFacingRight() then
						actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, .2, .3, 1.5, .4, 0 )
					else
						actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, -.2, .3, 1.5, .4, 0 )
					end
				elseif frame == 5 then
					actor:ClearPhysicsboxes()
					
					actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, .1, .5, .5, 0 )
					if actor:IsFacingRight() then
						actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, .2, .3, 2.25, .4, 0 )
					else
						actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, -.2, .3, 2.25, .4, 0 )
					end
				elseif frame == 6 then
					actor:ClearPhysicsboxes()
					
					actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, .1, .5, .5, 0 )
					if actor:IsFacingRight() then
						actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, .2, .3, 3, .4, 0 )
					else
						actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, -.2, .3, 3, .4, 0 )
					end
				end
			elseif frame == 2 then
				if airDashingRight then
					actor:SetVelocity( math.max( actor:GetVelocity().x, airDashSpeed ), 0 )
                else
					actor:SetVelocity( math.min( actor:GetVelocity().x, -airDashSpeed ), 0 )
                end
			elseif frame == 3 then
				actor:SetSpriteOffset( 0, 0, .5 )
			end
			
			
			local xOffset = 1.25
			local yOffset = .3
			
			if frame > 5 then
                if actor:IsFacingRight() then
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset, yOffset, 1, 2, 0 )
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, .5, -.75 + yOffset, .5, .5, 0 )
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, .5,  .75 + yOffset, .5, .5, 0 )
                else
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset, yOffset, 1, 2, 0 )
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -.5, -.75 + yOffset, .5, .5, 0 )
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -.5,  .75 + yOffset, .5, .5, 0 )
                end
			end
			
			if frame % 5 == 0 or frame == 1 then--and not (touchingLeftWall or touchingRightWall) then
				local rpos = ACTOR:b2Vec2()
				--local tempA = math.atan2( groundNormal.x, -groundNormal.y )
				
				local xmove = 0
				local ymove = 0
				rpos.x = actor:GetPosition().x
				
				if actor:IsFacingRight() then
					rpos.x = rpos.x - .5
				else
					rpos.x = rpos.x + .5
				end
				
				rpos.y = actor:GetPosition().y
				if actor:IsReversed() then
					rpos.y = rpos.y - .5
				else
					rpos.y = rpos.y + .5
				end
				
				local vel = ACTOR:b2Vec2()
				vel.x = 0
				vel.y = 0
				stage:CreateActor( "airdashdustrepeat", rpos, vel, actor:IsFacingRight(), actor:IsReversed(), 0, actor )
				--rpos.y = rpos.y - .5
				if actor:IsFacingRight() then
					rpos.x = rpos.x + 1.5
				else
					rpos.x = rpos.x - 1.5
				end
				--stage:CreateActor( "airdashdustrepeat", rpos, vel, actor:IsFacingRight(), actor:IsReversed(), 0, actor )
				
			end
        end
       
        actorLeftWallJump = false
        actorRightWallJump = false
       
        if action == dash then

			if currentInput:Right() and not actor:IsFacingRight() then
				actor:FaceRight()
				framesDashing = 0
				frame = 1
			elseif currentInput:Left() and actor:IsFacingRight() then
				actor:FaceLeft()
				frame = 1
				framesDashing = 0
			end
			
			if framesDashing == 2 then				
				
				local pos = ACTOR:b2Vec2()
				local vel = ACTOR:b2Vec2()
				vel.x = 0
				vel.y = 0
				
				pos.x = actor:GetPosition().x
				if actor:IsReversed() then
					pos.y = actor:GetPosition().y - .15625
				else
					pos.y = actor:GetPosition().y + .15625
				end
				
				stage:CreateActor( "dashdust", pos, vel, actor:IsFacingRight(), actor:IsReversed(), angle/ math.pi, actor )
				
			elseif framesDashing % 5 == 0 and framesDashing > 0 and not (touchingLeftWall or touchingRightWall) then
				local rpos = ACTOR:b2Vec2()
				local tempA = math.atan2( groundNormal.x, -groundNormal.y )
				
				local xmove = 0
				local ymove = 0
				rpos.x = actor:GetPosition().x
				
				rpos.y = actor:GetPosition().y
				if actor:IsReversed() then
					rpos.y = rpos.y - .5
				else
					rpos.y = rpos.y + .5
				end
				
				local vel = ACTOR:b2Vec2()
				vel.x = 0
				vel.y = 0
				stage:CreateActor( "dashdustrepeat", rpos, vel, actor:IsFacingRight(), actor:IsReversed(), angle / math.pi, actor )
				
			end
			
			local a = angle
			local c = math.cos( a )
			local s = math.sin( a )
			if prevAction ~= dash then
				actor:ClearPhysicsboxes()
				--actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .5, .5, 0 )
				actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, .35, .5, .8, 0 )
			end
		   
			actor:ClearHurtboxes()
			local xOffset = 0
			local yOffset = .35
			if actor:IsFacingRight() then
				actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, 1, .8, a )
			else
				actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, 1, .8, a        )
			end
   
			framesDashing = framesDashing + 1
		   
			if actor:IsFacingRight() and actor:GetVelocity().x <= dashSpeed then
					actor:SetVelocity( dashSpeed, actor:GetVelocity().y )
			elseif not actor:IsFacingRight() and actor:GetVelocity().x >= -dashSpeed then
					actor:SetVelocity( -dashSpeed, actor:GetVelocity().y )
			end
        else
			framesDashing = 0
        end

		
        if grounded and not lastGrounded and action ~= stand and action ~= fastFall and action ~= slide and action ~= airDash and action ~= speedBall then--( currentInput.Left() or currentInput.Right() ) then

			local newX = 0
			
			if math.abs(actor:GetVelocity().x) > math.abs(prevVelocity.x) then
				if prevVelocity.x >=0 then
					newX = prevVelocity.x + 4 * ( 1 - (maxFallVelocity - prevVelocity.y ) / maxFallVelocity )
				else
					newX = prevVelocity.x - 4 * ( 1 - (maxFallVelocity - prevVelocity.y ) / maxFallVelocity )
				end
			else
				newX = prevVelocity.x
			end
			
		    actor:SetVelocity( newX, newX * -groundNormal.x / groundNormal.y )
			
			
			if rcCount == 0 then
				print( "ERROR: rcCount == 0 and grounded" )
			else
				--print( "lock1" )
				--print( "just hit the ground lock" )
				if actor:IsReversed() then
				   actor:SetPosition( actor:GetPosition().x, minGroundY + playerHeight )
				else
					--print( "lock1" )
				   actor:SetPosition( actor:GetPosition().x, minGroundY - playerHeight )
				end
			end
        elseif not grounded and lastGrounded and currentInput.A then
			if actor:GetVelocity().y < 0 and groundNormal.x ~= 0 then
				actor:SetVelocity( prevVelocity.x, actor:GetVelocity().y )
			end				
        end
       
        if slopeSlow then
			slopeSlow = false
	    end
       
       
    
        --this allows for slight slowing during an air dash. We can decide later if we like it or not. ( currently removed )
        if ( action ~= wallJump or ( action == wallJump and frame > 10 )) and not grounded and action ~= airDash and action ~= gravitySlash and action ~= hitstun and action ~= speedBall and action ~= forcedSlide then
				if airControlLock > 0 then
					airControlLock = airControlLock - 1
				else
					if currentInput:Left() then
							if actor:GetVelocity().x > -airMaxControlSpeed then
									--print( "applying impulse" )
									actor:SetVelocity( math.max( -airMaxControlSpeed, actor:GetVelocity().x - airControlSpeed ), actor:GetVelocity().y  )
									--actor:ApplyImpulse( math.max( -airControlSpeed, -airMaxControlSpeed - actor:GetVelocity().x ), 0 )
							end
					elseif currentInput:Right() then
							if actor:GetVelocity().x < airMaxControlSpeed then
							--      print( "applying impulse" )
									--actor:ApplyImpulse( math.min( airControlSpeed, airMaxControlSpeed - actor:GetVelocity().x ), 0 )
									actor:SetVelocity( math.min( airMaxControlSpeed, actor:GetVelocity().x + airControlSpeed ), actor:GetVelocity().y  )
							end
					elseif not ( currentInput:Up() or currentInput:Down() ) then
							if actor:GetVelocity().x > 0 then
									actor:SetVelocity( math.max( 0, actor:GetVelocity().x - airSlowSpeed ), actor:GetVelocity().y  )
							elseif actor:GetVelocity().x < 0 then
									actor:SetVelocity( math.min( 0, actor:GetVelocity().x + airSlowSpeed ), actor:GetVelocity().y  )
							end
					end
				end
        end
       
 
        if action ~= dash and action ~= airDash and action ~= dashAttack and action ~= speedBall then--and prevAction == dash then
       
                actor:ClearHurtboxes()
                --actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, 0, 0, .5, 1.5, actor:GetAngle() * 3 )
                actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, 0, 0, .5, 1.5, angle )
                if ( prevAction == dash or prevAction == airDash or prevAction == dashAttack) then
                        actor:ClearPhysicsboxes()
						--actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .5, .5, 0 )
                        actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .5, 1.5, 0 )
						
						--this is for when the airdash collides with the tilted ground. it might malfunction on moving platforms.
						local xx = 0
						if grounded and prevAction == airDash then
						if math.abs( groundNormal.y ) > .8 then
							xx = -.05
						else
							xx = .2
						end
						end
						--print( "groundnormal: " .. groundNormal.y )
						print( "has nothing to do with dashing lock" )
						if actor:IsFacingRight() then
							actor:SetPosition( actor:GetPosition().x + xx, actor:GetPosition().y )
						else
							actor:SetPosition( actor:GetPosition().x - xx, actor:GetPosition().y )
						end
						
						playerWidth = .25
						playerHeight = .75
						centerOffsetX = 0
						actor:SetSpriteOffset( 0, 0, -.05 )
                end
				
               
                
        end
		
		if action ~= airDash and prevAction == airDash then
		--	actor:ClearPhysicsboxes()
		--	actor:CreateBox( bodyTypes.Normal, Layer_PlayerPhysicsbox, 0, 0, .5, 1.5, 0 )
			
		--	 actor:ClearHurtboxes()
                --actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, 0, 0, .5, 1.5, actor:GetAngle() * 3 )
         --    actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, 0, 0, .5, 1.5, angle * 3.5 )
		end
		
		
      
        if action == doubleJump and frame < 15 then
                --actor:SetSpriteOffset( 0,-1 * frame / 15 )
        end
		
		
		if action == jump and ((grounded and touchingRightWall and actor:IsFacingRight()) or (grounded and touchingLeftWall and not actor:IsFacingRight())) then
                --SetAction( stand )
                --frame = 1
				
				grounded = false
				actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y * 3 / 4 )
        end
        --print( "before d: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
        if grounded and action ~= dash and action ~= hitstun then
				if action ~= slide then				
					if currentInput:Left() then
						if action ~= runningAttack or not actor:IsFacingRight() then
							if actor:GetVelocity().x > 0 then
									actor:SetVelocity( 0, 0 )
							end
							if actor:GetVelocity().x > -groundMaxControlSpeed then
									actor:SetVelocity( math.max( -groundMaxControlSpeed, actor:GetVelocity().x - groundControlSpeed ), actor:GetVelocity().y  )
							else
									actor:SetVelocity( math.max( -maxVelocity.x, actor:GetVelocity().x), actor:GetVelocity().y )
							end
						elseif action == runningAttack then
							if actor:GetVelocity().x >= 0 then
									actor:SetVelocity( -groundMaxControlSpeed, 0 )
									actor:FaceLeft()
							end
						end
					elseif currentInput:Right() then
						if action ~= runningAttack or actor:IsFacingRight() then
							if actor:GetVelocity().x < 0 then
									actor:SetVelocity( 0, 0 )
							end
							if actor:GetVelocity().x < groundMaxControlSpeed then
									actor:SetVelocity( math.min( groundMaxControlSpeed, actor:GetVelocity().x + groundControlSpeed), actor:GetVelocity().y )
							else
									actor:SetVelocity( math.min( maxVelocity.x, actor:GetVelocity().x), actor:GetVelocity().y )
							end
						elseif action == runningAttack then
							if actor:GetVelocity().x <= 0 then
									actor:SetVelocity( groundMaxControlSpeed, 0 )
									actor:FaceRight()
							end
						end
					end
				end
               
                if currentInput:Left() or currentInput:Right() or action == runningAttack then
                        if actor:GetVelocity().y < 0 and groundNormal.x ~= 0 then
                                if actor:IsFacingRight() and currentInput:Right() and not prevInput:Right() then
                                        --actor:SetVelocity( actor:GetVelocity().x - actor:GetVelocity().y, actor:GetVelocity().y )
                                        --print( "--------------------------------------------------------" )
                                elseif not actor:IsFacingRight() and currentInput:Left() and not prevInput:Left() then
                                        --actor:SetVelocity( actor:GetVelocity().x + actor:GetVelocity().y, actor:GetVelocity().y )
                                end
                        end
                       
                        --print( "before c: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y  )
                        actor:SetVelocity( actor:GetVelocity().x, -actor:GetVelocity().x * groundNormal.x / groundNormal.y )
                        --print( "c: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
                        --actor:SetVelocity( actor:GetVelocity().x, -actor:GetVelocity().x * groundNormal.x / groundNormal.y )
                        --actor:SetVelocity( prevVelocity.x, -prevVelocity.x * groundNormal.x / groundNormal.y )
                end
                --print( "d: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
        elseif grounded and action == dash then
                --print( "before e: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
                if ( actor:GetVelocity().x > 0 and groundNormal.x < 0 ) or ( actor:GetVelocity().x < 0 and groundNormal.x < 0 ) then
                        actor:SetVelocity( actor:GetVelocity().x, -actor:GetVelocity().x * groundNormal.x / groundNormal.y )
                elseif ( actor:GetVelocity().x > 0 and groundNormal.x > 0 ) or ( actor:GetVelocity().x < 0 and groundNormal.x > 0 ) then
                        actor:SetVelocity( actor:GetVelocity().x, -actor:GetVelocity().x * groundNormal.x / groundNormal.y )
                else
                        actor:SetVelocity( actor:GetVelocity().x, 0 )
                end
                --print( "e: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
        end
        
		if action == runningAttack then
			actor:SetSpriteOffset( 0, 1, 0 )
			if actor:IsFacingRight() then
				--actor:SetSpriteOffset( 0, 1, 1 )
			else
				--actor:SetSpriteOffset( 0, -1, -1 )
			end
			--if frame >=4 and frame <= 5 then
			Sword( .5,0, 1, 1.5 )
			
		end
		
		if action == run then
			actor:SetSpriteOffset( 0, 0, -.25 )
		end
		
		
        local a = angle
        local c = math.cos( a )
        local s = math.sin( a )
        --jump action will eventually mean ascending only, not the fall
        --+why do i need gravity while standing?
        --if ( not grounded ) and action ~= airDash then--or action == stand then
		
		if action == speedBall then
			--grav = .5
		end
		
        if action ~= airDash then--and action ~= speedBall then
        --if not grounded and action ~= airDash then
                if ( action == stand or action == dashToStand ) and trueGrounded then	
				--	actor:SetVelocity( actor:GetVelocity().x - groundNormal.x * grav, actor:GetVelocity().y - groundNormal.y *  grav )
                elseif not trueGrounded then		
					--actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + grav )
                end
				
				if not grounded then
					actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + grav )
				elseif actor:GetVelocity().x == 0 then
					actor:SetVelocity( actor:GetVelocity().x - groundNormal.x * .001, actor:GetVelocity().y - groundNormal.y * .001 )
					
					--print( "testing" )
				end
				
				
                --actor:ApplyImpulse( 0, grav )
        end
		slopeAccel = false
        if currentInput:Down() and grounded and actor:GetVelocity().y > 0 and (action == run or action == standToRun or action == dash) then
		
			if action == dash or (currentInput:Left() or currentInput:Right() ) then
                --print( "down" )
				--accel = .8 * ( maxVelocity.x / math.abs( actor:GetVelocity().x ) ) * .25
				--accel = ( 1 - math.abs( actor:GetVelocity().x / maxVelocity.x ) ) * 1 + .6
				accel = .8
				--accel =  * ( maxVelocity.x / math.abs( actor:GetVelocity().x ) ) * 1
				accel = math.min( accel, .97 )
				accel = math.max( accel, .3 )
				--print( "accel: " .. accel )
				slopeAccel = true
                actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + accel * math.abs( groundNormal.x / groundNormal.y ) )
				--print( "setvel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
				--print( "accel: " .. accel )
              end

			   --actor:ApplyImpulse( 0, 1 * math.abs( groundNormal.x / groundNormal.y ) )
				--print( "here: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
        end    
       
        --dashing up a slope, etc
        if grounded and not trueGrounded and not currentInput:Up() and not rampSlopeAdjust and action ~= slide and action ~= speedBall then
				--print( "lock2" )
				print( "not truegrounded lock" )
                if actor:IsReversed() then
                        actor:SetPosition( actor:GetPosition().x, minGroundY + playerHeight )
                else
                        actor:SetPosition( actor:GetPosition().x, minGroundY - playerHeight )
                end
            --   end
        else
                --print( "------------------------------------------------------" )
        end
      
		
		if grounded and action == airDash then
			print( "here" )
			if actor:IsReversed() then
				  -- actor:SetPosition( actor:GetPosition().x, minGroundY + playerHeight )
			else
					--print( "lock1" )
				--   actor:SetPosition( actor:GetPosition().x, minGroundY - playerHeight )
			end
		end
       
        if grounded and (touchingLeftWall or touchingRightWall ) then
			if touchingRightWall and actor:GetVelocity().x > 0 then
				actor:SetVelocity( 0,0 )
			elseif touchingLeftWall and actor:GetVelocity().x < 0 then
				actor:SetVelocity( 0,0 )
			end
        end
       
        if action == groundComboAttack1 then--and frame > 5 and frame < 15 then
			--actor:ClearHitboxes()
			if frame == 1 then
				local xso = 0--1.4
				local yso = -1---1.2
				if not actor:IsFacingRight() then
					xso = -xso
				end
				--actor:SetSpriteOffset( 0, xso, yso )
				--actor:SetSpriteScale( 0, 1.3, 1.3 )
			end
			
			
			actor:SetVelocity( 0, 0 )
			local xOffset = 1
			local yOffset = 0
			if actor:IsFacingRight() then
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, 1.5, 1, a )
			else
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, 1.5, 1, a )
			end
			
			if frame > 1 and currentInput.X and not prevInput.X then
				if groundComboAttack2Buffered then
					groundComboAttack3Buffered = true
				else
					groundComboAttack2Buffered = true
				end
			end
		elseif action == groundComboAttack2 then--and frame > 5 and frame < 15 then
			--actor:ClearHitboxes()
			if frame == 1 then
				local xso = 1
				if not actor:IsFacingRight() then
					xso = -xso
				end
			end
			
			
			actor:SetVelocity( 0, 0 )
			local xOffset = 1
			local yOffset = -.75
			if actor:IsFacingRight() then
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, 1.5, 3, a )
			else
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, 1.5, 3, a )
			end
			
			if frame > 1 and currentInput.X and not prevInput.X and not groundComboAttack3Buffered then
				groundComboAttack3Buffered = true
			end
		elseif action == groundComboAttack3 then--and frame > 5 and frame < 15 then
				--actor:ClearHitboxes()
				if frame == 1 then
					local xso = 1
					if not actor:IsFacingRight() then
						xso = -xso
					end
				end
				
                actor:SetVelocity( 0, 0 )
                local xOffset = 2
                local yOffset = -1
                if actor:IsFacingRight() then
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, 4, 3.5 , a )
                else
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, 4, 3.5, a )
                end
		elseif action == upGroundAttack then
				actor:SetVelocity( 0, 0 )
                local xOffset = 0
                local yOffset = -2.25
                if actor:IsFacingRight() then
                        actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, 1, 3, a )
                else
                        actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, 1, 3, a )
                end
		elseif action == downGroundAttack then
				actor:SetVelocity( 0, 0 )
                local xOffset = 1.75
                local yOffset = .25
                if actor:IsFacingRight() then
                        actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, 3, 1, a )
                else
                        actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, 3, 1, a )
                end
                --print( "on" )
		elseif action == dashAttack then
			--actor:SetVelocity( 0, 0 )
			
			if math.abs( actor:GetVelocity().x ) < 5 then
				actor:SetVelocity( 0,0 )
			else
				actor:SetVelocity( actor:GetVelocity().x - actor:GetVelocity().x / 4, actor:GetVelocity().y - actor:GetVelocity().y / 4)
			end
			
			actor:ClearHurtboxes()
			local xOffsetHurt = 0
			local yOffsetHurt = .35
			if actor:IsFacingRight() then
					--print( "angle: " .. angle )
					actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, xOffsetHurt * c - yOffsetHurt * s, xOffsetHurt * s + yOffsetHurt * c, 1, .8, a )
			--      actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, .25, .35, 1, .8, 0 )
				   -- actor:SetSpriteOffset( 0, .5, -.05 )
					--centerOffsetX = .25
			else
				  --  actor:SetSpriteOffset( 0, -.5, -.05 )
					--actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, -.25, .35, 1, .8, actor:GetAngle() * 3 )
					actor:CreateBox( bodyTypes.Normal, Layer_PlayerHurtbox, -xOffsetHurt * c - yOffsetHurt * s, -xOffsetHurt * s + yOffsetHurt * c, 1, .8, a        )
			end
			
			local xOffset = 0
			local yOffset = -.5
			if actor:IsFacingRight() then
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, 1, 1, a )
			else
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, 1, 1, a )
			end
        elseif action == forwardAirAttack then
			--forwardAirAttack info
			
			if frame == 1 and actor:GetVelocity().y < 20 and not currentInput.A then
				--actor:SetVelocity( actor:GetVelocity().x, -10 )
			end
			
			--and frame >= 4 and frame < 19 then
			if frame >=4 and frame <= 5 then
				Sword( -.75,-.5, .5, .6 )
				
			elseif frame >=6 and frame <= 7 then
				Sword( .8,-.8, 1, 1 )
				Sword( .2,-.8, .5, .4 )
			elseif frame >=8 and frame <= 9 then
				Sword( 1.2,0, 1.5, 2 )
				--Sword( .8,0, 1.5, 2 )
			elseif frame >=10 and frame <= 11 then
				Sword( 1.2,0, 1, 2 )
				Sword( .5,.8, 2, 1 )
			elseif frame >=12 and frame <= 15 then
				Sword( 1.2,0, .6, 1 )
				Sword( .3,.5, 2, .5 )
				Sword( .3,.8, 1.3, .8 )
			elseif frame >=16 and frame <= 17 then
			elseif frame >= 18 and frame <= 19 then
				
			end
			--Sword( 1.25, 0, 2, 3 )
                
		elseif action == upAirAttack then
			--forwardAirAttack info
			if frame == 1 and actor:GetVelocity().y < 20 and not currentInput.A and math.abs( actor:GetVelocity().x ) <= 30 then
				actor:SetVelocity( actor:GetVelocity().x, -10 )
			end
			--and frame >= 4 and frame <= 12 
			if frame == 4 then
				Sword( -1, -.3, 1, 1.4 )
			elseif frame == 5 then
				Sword( -1, -.3, 1, 1.4 )
				Sword( -.5, -1.4, 1.7, 1.7)
				--Sword( -3, -1, 1, 1)
				--Sword( -1, -3, 1, 1)
			elseif frame == 6 then
				Sword( .3, -1.2, 3.5, 2)
				Sword( -1, -.3, 1, 1.4 )
			elseif frame >= 7 and frame <= 8 then
				Sword( 1, -.7, 1.8, 1.5 )
				Sword( .8, -1.6, 2.2, 1 )
			elseif frame >=9 and frame <= 10 then
				Sword( 1, -.6, 2, 1.5 )
			elseif frame == 11 then
				Sword( 1, 0, 1.5, .5 )
			elseif frame == 12 then
				Sword( .5, 0, 1, .5 )
			end
		elseif action == downAirAttack then
			--and frame >= 4 and frame < 13 then
			if frame == 1 and actor:GetVelocity().y < 20 and not currentInput.A and math.abs( actor:GetVelocity().x ) <= 30 then
				actor:SetVelocity( actor:GetVelocity().x, -10 )
			end
			--forwardAirAttack info
			local xOffset = 1.25

			local yOffset = 0
			if actor:IsFacingRight() then
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, 2, 3, a )
			else
					actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, 2, 3, a )
			end
        end
       
        if action == hitstun then
				print( "action is hitstun" )
                if frame == 2 then
                        if actor:IsFacingRight() then
                                actor:SetVelocity( -3, actor:GetVelocity().y  )
                        else
                                actor:SetVelocity( 3, actor:GetVelocity().y  )
                        end
                end
               
               
        end
		
		if action == slide then
			actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + slideGrav )
		end
       
	   
	  --  if action == run or action == dash or action == jump or action == doubleJump then
		
		--print( "before carry: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
		
		--print( "after carry: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
        --actor:SetVelocity( actor:GetVelocity().x - carryVel.x, actor:GetVelocity().y - carryVel.y )
		
end
 
 function Spawn()
	actor:SetVelocity( 0, 0 )
	health = maxHealth
	
	action = stand
	prevAction = nil
	prevFrame = 1
	frame = 1
	groundLockActor = nil
	carryVel.x = 0
	carryVel.y = 0
	player:SetCarryVelocity( 0, 0 )
	actor.health = maxHealth
	--actor:SetPosition( originalPos.x, originalPos.y )
	grounded = false
	print( "spawn" )
	--stage:SetCameraPosition( actor:GetPosition().x, actor:GetPosition().y )
	--stage:SetCameraZoom( 1 )

 end
 
function UpdatePrePhysics()    
		player.dropThroughFlag = false
		player.cancelDropFlag = false
		
        if hitlagFrames > 0 then               
                hitlagFrames = hitlagFrames - 1
                if hitlagFrames == 0 and action ~= hitstun then -- and aggressor
                        actor:SetVelocity( hitlagVel.x, hitlagVel.y )    
						hitlagVelSet = false
                else
						--actor:SetVelocity( 0, 0 )
						--actor:SetVelocity( 
						--actor:SetVelocity( prevVelocity.x, prevVelocity.y )    
                        --actor:SetVelocity( actor:GetVelocity().x + specialVel.x, actor:GetVelocity().y + specialVel.y )
                        actor:SetSprite( 0, action[frame][1], action[frame][2] )
						--print( "early ending" )
                        return
                end
        end
       
               
       
        if reverseGravityCounter == 1 then
                actor:SetVelocity( actor:GetVelocity().x, 0 )
        end
 
 
        actionChanged = false
       
        ActionEnded()
       
        actor:ClearHitboxes()
     
		local trueMid = actor:GetPosition().x + centerOffsetX --- playerHeight * math.sin( -actor:GetAngle() )
        local trueRight = trueMid + playerWidth --* math.cos( -actor:GetAngle() )
        local trueLeft = trueMid - playerWidth --* math.cos( -actor:GetAngle() )
		
        rightX = 0
        rightY = 0
       
        leftX = 0
        leftY = 0
       
         midX = 0
         midY = 0
       
        rightNormX = 0
        rightNormY = 0
       
        leftNormX = 0
        leftNormY = 0
       
        midNormX = 0
        midNormY = 0
       
        rightSuccess = false
        leftSuccess = false
        midSuccess = false
       
        minGroundY = -1 --highest point of ground from the 3 tests
       
      
        oldGroundNormal.x = groundNormal.x
        oldGroundNormal.y = groundNormal.y
		
		
	   
        local dist = .8 --1
        --probably should use some algorithm here
        if math.abs( actor:GetVelocity().x ) > 40 then
                dist = 1.5
		--else
		--	dist = .9
        end
        rcCount = 0
       
		actor:RayCast( trueRight, actor:GetPosition().y, trueRight, actor:GetPosition().y + playerHeight + dist, --[[actor:GetWorldBottom() + dist,--]] Layer_Environment )
		
        rightX = rcPoint.x
        rightY = rcPoint.y
		
        if rcCount == 1 then
			groundNormal.x = rcNormal.x
			groundNormal.y = rcNormal.y
			minGroundY = rcPoint.y
			rightNormX = rcNormal.x
			rightNormY = rcNormal.y
			rightSuccess = true
        end
       
        rcFraction = 0
        actor:RayCast( trueLeft, actor:GetPosition().y, trueLeft, actor:GetPosition().y + playerHeight + dist, Layer_Environment )
        leftX = rcPoint.x
        leftY = rcPoint.y
       
        if rcFraction > 0 then
			leftNormX = rcNormal.x
			leftNormY = rcNormal.y
			leftSuccess = true
        end
       
       
        if rcCount > 0 and ( minGroundY < 0 or ( (not actor:IsReversed() and rcPoint.y < minGroundY)
			or ( actor:IsReversed() and rcPoint.y > minGroundY ) ) ) then
				groundNormal.x = rcNormal.x
				groundNormal.y = rcNormal.y
				minGroundY = rcPoint.y
        end
       
        rcFraction = 0
        actor:RayCast( trueMid, actor:GetPosition().y, trueMid, actor:GetPosition().y + playerHeight + dist, Layer_Environment )
        midX = rcPoint.x
        midY = rcPoint.y
       
        if rcFraction > 0 then
                midNormX = rcNormal.x
                midNormY = rcNormal.y
                midSuccess = true
        end
       
        if rcCount > 0 and ( minGroundY < 0 or ( (not actor:IsReversed() and rcPoint.y < minGroundY)
			or ( actor:IsReversed() and rcPoint.y > minGroundY ) ) ) then
                groundNormal.x = rcNormal.x
                groundNormal.y = rcNormal.y
                minGroundY = rcPoint.y
        end
       
        if rcCount == 3 and ( leftNormX < 0 and rightNormX > 0 ) then
			groundNormal.x = 0
			groundNormal.y = -1
        end

		if rcCount == 3 and ( leftNormX > 0 and rightNormX < 0 ) then
			grav = 2
			if actor:IsFacingRight() and midNormX == rightNormX then
				groundNormal.x = rightNormX
				groundNormal.y = rightNormY
			elseif not actor:IsFacingRight() and midNormX == leftNormX then
				groundNormal.x = leftNormX
				groundNormal.y = leftNormY
			else
				groundNormal.x = 0
				groundNormal.y = -1
				grav = 0
			end
		else
			grav = 2
		end
		
		if action == wallCling then 
			maxFallVelocity = 10
			
			if actor:GetVelocity().y > -extraVel then
				--grav = -1
			elseif actor:GetVelocity().y < -extraVel then
				--grav = 1
			end
			
			--grav = 0

		else
			--grav = 2
			maxFallVelocity = 60--84--40
		end
		  
		--print( "rccount: " .. rcCount )
		--print( "groundnormal: " .. groundNormal.x .. ", " .. groundNormal.y )
		
        if trueGrounded then
                grounded = true
				
        end
		
		if groundNormal.y >= -.5 then
			grounded = false
			
		end
		
        if lastGrounded and rcCount > 0 and ( action == stand or action == dashToStand or action == run or action == standToRun or action == dash or action == dashAttack or action == groundComboAttack1 or action == groundComboAttack2 or action == groundComboAttack3 or action == upGroundAttack or action == downGroundAttack or action == runningAttack or action == nil ) then
				if groundNormal.y < -.5 then
				grounded = true
				else
				grounded = false
				
				end
        elseif not trueGrounded and ( rcCount == 0 or (rcCount == 1 and actor:GetVelocity().y < 0) ) then
                grounded = false
				
        end
		
		rampSlopeAdjust = false
		if rcCount < 3 and groundNormal.y ~= 0 then
		--	trueGrounded = false
			if leftSuccess and groundNormal.x < 0  or rightSuccess and groundNormal.x > 0 then
				--grounded = false
				if math.abs(actor:GetVelocity().x) <= groundMaxControlSpeed then
					groundNormal.x = 0
					groundNormal.y = -1					
					oldGroundNormal.x = 0
					oldGroundNormal.y = -1
				end
				rampSlopeAdjust = true
			--print( "here" )
			end
		end
		

	
		--hold up to hold your momentum off of a cliff
		if ((oldGroundNormal.x > 0 and groundNormal.x <= 0 and actor:GetVelocity().x < 0) 
			or (oldGroundNormal.x < 0 and groundNormal.x >= 0 and actor:GetVelocity().x > 0)) and currentInput:Up() then
			grounded = false
			
	    end
		
		if slopeSlow then
			grounded = false
			
		end
		
		if forcedAirCounter > 0 then
			
			grounded = false
			lastGrounded = false
			forcedAirCounter = forcedAirCounter - 1
		end
		
        if grounded then
                framesInAir = 0
                hasDoubleJump = true
                hasAirDash = true
				hasTether = true
                if gravityReverseCounter == 0 then
                        hasGravitySlash = true
                end
			--	grav = 0
		else
			--grav = 2
        end
		
		
       
        if gravityReverseCounter > 0 then
                gravityReverseCounter = gravityReverseCounter + 1
                if gravityReverseCounter == gravityReverseLimit or ( not grounded and gravityReverseCounter > 5 ) then-- or not grounded then
                        actor:Reverse()
                        grounded = false

                        gravityReverseCounter = 0
                end
        end
		

		--if action == speedBall then
		--	grounded = false
		--end

		
		
		if grounded then--or math.abs( actor:GetVelocity().x ) > math.abs( actor:GetVelocity().x - carryVel.x ) then
		--actor:SetVelocity( actor:GetVelocity().x - carryVel.x, actor:GetVelocity().y )

		actor:SetVelocity( actor:GetVelocity().x - carryVel.x, actor:GetVelocity().y )
	    
		end
		--actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y - carryVel.y )
		--actor:SetVelocity( actor:GetVelocity().x - carryVel.x, actor:GetVelocity().y - carryVel.y )
		
		actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y - carryVel.y )
		
		player:SetCarryVelocity( carryVel.x, carryVel.y )
		--print( "carry vel: " .. player:GetCarryVelocity().x .. ", " .. player:GetCarryVelocity().y )
		carryVel.x = 0
		carryVel.y = 0
		
       
        ChooseAction()
 		
        if framesInAir > 5 then--or ( rcCount == 1 and groundNormal.x ~= 0 ) then
			angle = 0
        elseif rcCount > 0 and grounded then
			local testX = actor:GetPosition().x
			local testY = actor:GetPosition().y
		
			if action == dash or action == dashAttack or action == groundComboAttack1 or action == groundComboAttack2 or action == groundComboAttack3 or action == slide or action == runningAttack then
				angle = math.atan2( groundNormal.x, -groundNormal.y )--ath.atan2( groundNormal.y/groundNormal.x )--groundNormal.x / math.pi
			else
				angle = math.atan2( groundNormal.x, -groundNormal.y ) / 2--groundNormal.x / math.pi / 2
			end
			
			if rightNormX ~= leftNormX then
				local testNormX = (rightNormX + leftNormX) / 2
				local testAngle = testNormX / math.pi / 2 
			end
        end
		
        if groundLockActor ~= nil then				
			if grounded then
				carryVel.x = carryVel.x + groundLockActor:GetVelocity().x 
			end
			groundLockActor = nil
        end

        if grounded and action ~= stand and action ~= slide then
			local lol = math.abs( actor:GetVelocity().x ) - math.abs( prevVelocity.x )
			local abslol = math.abs( lol )
			if slopeAccel then
				abslol = abslol - accel 
			end
			
			if abslol > .001 then
				--print( "lock3: " .. oldGroundNormal.y .. ", " .. groundNormal.y )
				if math.abs( oldGroundNormal.y - groundNormal.y ) > .001 then
					if actor:IsReversed() then
							actor:SetPosition( actor:GetPosition().x, minGroundY + playerHeight )
					else
							--print( "lock3" )
							actor:SetPosition( actor:GetPosition().x, minGroundY - playerHeight )
					end
				end
			   
				if actor:GetVelocity().y < 0 and groundNormal.x ~= 0 then
					actor:SetVelocity( prevVelocity.x, prevVelocity.x * -groundNormal.x / groundNormal.y )
				elseif actor:GetVelocity().y > 0 and groundNormal.x ~= 0 and lastGrounded then
					actor:SetVelocity( prevVelocity.x, prevVelocity.x * -groundNormal.x / groundNormal.y )
				end
			end
        end
       
       
        HandleAction()
      
	    if action == dash or action == run then
			if touchingRightWall and actor:GetVelocity().x >= 0 then
				actor:SetVelocity( 0, 0 )
			elseif touchingLeftWall and actor:GetVelocity().x <= 0 then
				actor:SetVelocity( 0, 0 )
			end
	    end
		
		
	   
        if rcCount < 3 and not grounded and trueGrounded and groundNormal.y ~= 0 then
		--	trueGrounded = false
			local slopeSpeed = 7
			if leftSuccess and actor:GetVelocity().x >= 0 and groundNormal.x < 0 then
				actor:SetVelocity( math.max( slopeSpeed, actor:GetVelocity().x ), actor:GetVelocity().y )
				print( "facing right" )
			elseif rightSuccess and actor:GetVelocity().x <= 0 and groundNormal.x > 0 then
				actor:SetVelocity( math.min( -slopeSpeed, actor:GetVelocity().x ), actor:GetVelocity().y )
				print( "facing left" )
			end
		end
		
		if hitlagFrames > 0 then
			actor:SetVelocity( 0, 0 )
		end

       
	    actor:SetVelocity( actor:GetVelocity().x + carryVel.x, actor:GetVelocity().y + carryVel.y )
	   
        --actor:SetVelocity( actor:GetVelocity().x + specialVel.x, actor:GetVelocity().y + extraVel.y )
        actor:SetVelocity( actor:GetVelocity().x + specialVel.x, actor:GetVelocity().y + specialVel.y )
		if specialVel.x ~= 0 or specialVel.y ~= 0 then
			print( "set special vel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
		end
		
        --max velocity checking
       
        if actor:GetVelocity().x > maxVelocity.x then
                actor:SetVelocity( maxVelocity.x, actor:GetVelocity().y )
        elseif actor:GetVelocity().x < -maxVelocity.x then
                actor:SetVelocity( -maxVelocity.x, actor:GetVelocity().y )
        end
       
        if action == fastFall then
                if actor:GetVelocity().y > fastFallMax then
                        actor:SetVelocity( actor:GetVelocity().x, fastFallMax )
                end
        elseif grounded then
                if actor:GetVelocity().y > maxVelocity.y then
                        actor:SetVelocity( actor:GetVelocity().x, maxVelocity.y )
                elseif actor:GetVelocity().y < -maxVelocity.y then
                        actor:SetVelocity( actor:GetVelocity().x, -maxVelocity.y )
                end
        else
                if actor:GetVelocity().y > maxFallVelocity then
                        actor:SetVelocity( actor:GetVelocity().x, maxFallVelocity )
                elseif actor:GetVelocity().y < -maxVelocity.y then
                        actor:SetVelocity( actor:GetVelocity().x, -maxVelocity.y )
                end
        end
       


        actor:SetSprite( 0, action[frame][1], action[frame][2] )
		
        actor:SetSpriteAngle( 0, angle / math.pi )
		

 
        trueGrounded = false
        lastGrounded = grounded
		
        grounded = false
        touchingRightWall = false
        touchingLeftWall = false
        prevAction = action
        prevFrame = frame
		
		onSteepLeftSlope = false
		onSteepRightSlope = false
		

	   
   ---   print( "vel1: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
       
        prevPosition.x = actor:GetPosition().x
        prevPosition.y = actor:GetPosition().y
        prevVelocity.x = actor:GetVelocity().x - carryVel.x
        prevVelocity.y = actor:GetVelocity().y - carryVel.y
        collisionPoint1.x = -1
        collisionPoint1.y = -1
        collisionPoint2.x = -1
        collisionPoint2.y = -1
		
        specialVel.x = specialVel.x + specialAcc.x
        specialVel.y = specialVel.y + specialAcc.y
end
 
function UpdatePostPhysics()
		
		--actor:SetVelocity( actor:GetVelocity().x - carryVel.x, actor:GetVelocity().y - carryVel.y )
		if action == speedBall then
		--	actor:SetPosition( player:GetSpeedBallPos().x, player:GetSpeedBallPos().y )
		end
		
		local leftState = player:GetTetherState( true )
		local rightState = player:GetTetherState( false )
			
		if leftState == "locked" and rightState == "locked" then
			player:LockTether( true )
			player:LockTether( false )
		end
		
		actor:SetFriction( 0 )
		if killed then
			--Spawn() 
			killed = false
			actor:Kill()
			
			if tetherOn then
				tetherOn = false
				tether:Message( actor, "explode", 0 )
			end
			print( "killed self" )
			return
        end
		
		if not player.cancelDropFlag and player.dropThroughFlag and lastGrounded then
			--player.dontDropThroughFlag = false
			actor:SetSprite( 0, jump[3][1], jump[3][2] )
			actor:SetSpriteOffset( 0, 0, 0 )
			
			trueGrounded = false
			lastGrounded = false
		end
		player.cancelDropFlag = false
		
       
    --   print( "vel2: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
        if hitlagFrames > 0 then
                return
        end
		
       
        if lastGrounded and (touchingRightWall or touchingLeftWall) and minGroundY >= 0 then
                --+can just figure out the height
                if (touchingRightWall and actor:GetVelocity().x >= 0) or ( touchingLeftWall and actor:GetVelocity().x <= 0 ) then
					if actor:GetVelocity().y >= -dashSpeed then
                        if actor:IsReversed() then
							actor:SetPosition( actor:GetPosition().x, minGroundY + playerHeight + .02 )
                        else
						   actor:SetPosition( actor:GetPosition().x, minGroundY - playerHeight - .02 )
                        end
					end
                end
        end
        --print( "vel2: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )

        frame = frame + 1
        if invincibilityFrames > 0 then
                invincibilityFrames = invincibilityFrames - 1
        --      print( "invinc: " .. invincibilityFrames )
        end
		
        if slopeSlow and math.abs( actor:GetVelocity().y ) < math.abs( actor:GetVelocity().x ) then
			print( "slope adjust: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
			actor:SetVelocity( prevVelocity.x, prevVelocity.x * -groundNormal.x / groundNormal.y )
			
	    end
		--print( "--------------------------------------" )
		--this is super buggy still TT
		if not reflector and not currentInput:Down() and actor:GetVelocity().y >= -extraVel and (action == jump or action == doubleJump or ( action == wallJump and frame > 15--[[25--]] ) or ( action == gravitySlash and frame > 18 ) ) and ( touchingRightWall and currentInput:Right() or touchingLeftWall and currentInput:Left() ) and action ~= airDash and action ~= wallCling then
		--if not lastGrounded and ( touchingRightWall and not currentInput:Left() or touchingLeftWall and not currentInput:Right() ) and action ~= wallJump and action ~= gravitySlash and action ~= airDash  then
		
			SetAction( wallCling )
			frame = 1
			--print( "lastGrounded: " .. lastGrounded )
			if touchingRightWall then
				actor:FaceLeft()
			else
				actor:FaceRight()
			end
			
			actor:SetSprite( 0, action[frame][1], action[frame][2] )
		end
		
		if actor:GetVelocity().y >= -extraVel and (action == jump or action == doubleJump or ( action == wallJump and frame > 15--[[25--]] ) or ( action == gravitySlash and frame > 18 ) ) and (onSteepLeftSlope or onSteepRightSlope) and action ~= airDash and action ~= forcedSlide then
			SetAction( forcedSlide )
			frame = 1
			
			if onSteepLeftSlope then
				actor:FaceRight()
			elseif onSteepRightSlope then
				actor:FaceLeft()
			end
			actor:SetSprite( 0, action[frame][1], action[frame][2] )
		end
			
		--collectgarbage()
end
 
function SetAction( newAction )
        if action ~= nil then
                CancelAction()
				actor:SetSpriteOffset( 0, 0, -.02 )
				actor:SetSpriteScale( 0, 1, 1 )
        end
        if action ~= newAction and newAction ~= nil then
                actionChanged = true
        end
        lastAction = action
        action = newAction
end
 
--for when you hit something
function HitActor( otherActor, hitboxTag )
        if hitboxTag == hitboxTypes.Heal then
                --print( "testing blah" )
        end
        --5
		
		ghostIndex = 0
		if hitboxTag >= 100 then
			ghostIndex = -1
			while hitboxTag >= 100 do
				hitboxTag = hitboxTag - 100
				ghostIndex = ghostIndex + 1
			end
			noHitlag = true --dont pause the actor for this
		end
		
		print( "hitbox tag: " .. hitboxTag )
        return hitboxStrings[hitboxTag], 10, 0, 0, 0

        --return type, damage, hitlag, hitstun, centerX (relative to this actor)
end
 
function ConfirmHit( otheractor, hitboxName, damage, hitlag, xx )
		if hitlagFrames == 0 then
			
		else
			--hitlagFrames = hitlagFrames + 1
		end
		if noHitlag then
			player:SetGhostHitlag( ghostIndex, hitlagFrames )
		else
			hitlagFrames = hitlag
			
			if hitlagFrames > 0 and not hitlagVelSet then
				hitlagVel.x = actor:GetVelocity().x
				hitlagVel.y = actor:GetVelocity().y
				actor:SetVelocity( 0, 0 )
				hitlagVelSet = true
			end
		end
		
		
end
 
--actor.health is inefficient and should only be updated/accessed once per frame
--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, xhitstun, hurtboxTag, hitboxCenterX )
		if hitboxName == "none" then
			return false --^^remove this soon
		end
		
        if invincibilityFrames > 0 then
                return false
        end
        --print( "hit by actor with hitboxName " .. hitboxName )
        actor.health = actor.health - damage
--      actor:Reverse()
        --print( "health: " .. actor.health )
        if actor.health <= 0 then
                killed = true
				
                --print( "YOU DIED" )
                --actor:Kill()
                actor.health = maxHealth
        end
        local hitSuccessful = false
        hitlagFrames = hitlag
		
		
        SetAction( hitstun )
		
		actor:SetSpriteOffset( 0, 0, 0 )
		actor:ClearHitboxes()
        frame = 1
        invincibilityFrames = 50
		if actor:GetVelocity().y >= 0 then
			actor:SetVelocity( 0, 0 )
		else
			actor:SetVelocity( 0, 0 )
			--actor:SetVelocity( 0, actor:GetVelocity().y )
		end
		
        if otherActor:GetPosition().x + hitboxCenterX >= actor:GetPosition().x then
                actor:FaceRight()
        else
                actor:FaceLeft()
        end
        
		if tetherOn then
			tether:Message( actor, "explode", 0 )
			tetherOn = false
		end
		
        --if hitlag > 0 then
        --      -
        --end
        return true
end
 
--when you collide with some Actor
function CollideWithActor( otherActor, tag, normal )

        return true, true
        --enable then active
        --returns a bool for whether this should count or not
end
 
--not sure if this is necessary yet
function HandleActorCollision( otherActor, hurtboxTag, pointCount, point1, point2, normal, enabled )
        --this will need to be adjusted later possibly, in the case of sloped enemy physicsboxes
        if not enabled then
                return
                --temporary
        end
       
       
        if normal.y < -.5 then
			if (action ~= jump and action ~= doubleJump) or (frame - 1) > 1 and ( framesInAir > 16 or actor:GetVelocity().y >= 0 or not currentInput.A ) then
			
				trueGrounded = true
				
				otherActor:Message( actor, "playergrounded", 0 )
				
				hasDoubleJump = true
				hasAirDash = true
				hasTether = true
				if gravityReverseCounter == 0 then
					hasGravitySlash = true
				end
				collisionPoint1.x = point1.x
				collisionPoint1.y = point1.y
				collisionPoint2.x = point2.x
				collisionPoint2.y = point2.y
			end
        elseif normal.y >= .5 and enabled and action == gravitySlash then
			actor:Reverse()
			frame = #action
			gravityReverseCounter = 1
        end
        local testY = point1.y
        if pointCount == 2 then
			testY = math.min( testY, point2.y )
        end
       
        if enabled and normal.x > wallThreshold and testY < actor:GetPosition().y + playerHeight - 0  then
			touchingLeftWall = true
        elseif enabled and normal.x < -wallThreshold and testY < actor:GetPosition().y + playerHeight - 0 then
			touchingRightWall = true
        end
end
 
function HandleStageCollision( pointCount, point1, point2, normal, enabled )	
		if enabled and action == speedBall then
		
			--actor:SetFriction( .2 )
			actor:SetFriction( 0 )
			--actor:SetRestitution( 1 )
			
			if normal.y < -.5 then
				hasDoubleJump = true
				hasAirDash = true
				hasGravitySlash = true
			end
		
			if actor:GetVelocity().x * -normal.x >= 10 or actor:GetVelocity().y * -normal.y >= 10 then
				if normal.y > 0 and currentInput:Up() or normal.y < 0 and currentInput:Down() or normal.x > 0 and currentInput:Left() 
					or normal.x < 0 and currentInput:Right() then
					actor:SetRestitution( .5 )
				else
					--actor:SetRestitution( .95 )
					if actor:GetVelocity().x * -normal.x >= 30 or actor:GetVelocity().y * -normal.y >= 30 then
						actor:SetRestitution( .9 )
					end
					if actor:GetVelocity().x * -normal.x >= 40 or actor:GetVelocity().y * -normal.y >= 40 then
						actor:SetRestitution( .9 )
					end
					actor:SetRestitution( .95 )
				end
			else
				actor:SetRestitution( 0 )
			end
		
		--	actor:SetPosition( player:GetSpeedBallPos().x, player:GetSpeedBallPos().y )
		--	print( "action is speed ball" )
		else
			actor:SetRestitution( 0 )
		end
		
        if normal.y < -.5 and enabled and action ~= speedBall then
			if not lastGrounded and currentInput:Down() and not ( currentInput:Right() or currentInput:Left() ) and normal.y > -1 then
				actor:SetFriction( slideLandFriction )
			elseif not lastGrounded and currentInput:Down() and not ( currentInput:Right() or currentInput:Left() ) then
				actor:SetFriction( 0 )
				--print( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" )
			elseif action == slide and normal.y > -1 then
				actor:SetFriction( slideFriction ) 
			elseif action == slide then
				actor:SetFriction( .3 ) 
			end
			
	
			if (action ~= jump and action ~= doubleJump) or frame > 1 and ( framesInAir > 16 or actor:GetVelocity().y >= 0 or not currentInput.A ) then
				
				
				trueGrounded = true
				if action == jump and framesInAir <=16 and currentInput.A and ((actor:GetVelocity().x > 0 and normal.x < 0) or (actor:GetVelocity().x < 0 and normal.x > 0 )) then
					slopeSlow = true
				end
				
				hasDoubleJump = true
				hasAirDash = true
				hasTether = true
				if gravityReverseCounter == 0 then
					hasGravitySlash = true
				end
				collisionPoint1.x = point1.x
				collisionPoint1.y = point1.y
				collisionPoint2.x = point2.x
				collisionPoint2.y = point2.y
			   
				--print( "point1: " .. point1.x .. ", " .. point1.y )
				--print( "grounded: " .. frame )
			elseif action == jump and framesInAir <=16 and currentInput.A and ((actor:GetVelocity().x > 0 and normal.x < 0) or (actor:GetVelocity().x < 0 and normal.x > 0 ))  then
				slopeSlow = true
			end
		elseif enabled and normal.y >= -.5 and normal.y < 0 then
			--print( "this one" )
			if normal.x > 0 then
				onSteepLeftSlope = true
			elseif normal.x < 0 then
				onSteepRightSlope = true
			end
			
			if not currentInput:Down() and actor:GetVelocity().y >= 0 then
				actor:SetFriction( 1 )
			else
				actor:SetFriction( 0 )
			end
        elseif normal.y > .5 and enabled and action == gravitySlash then
			actor:Reverse()
			frame = #action
			gravityReverseCounter = 1
        end
        local testY = point1.y
        if pointCount == 2 then
			testY = math.min( testY, point2.y )
        end
       
        if enabled and normal.x > wallThreshold and testY < actor:GetPosition().y + playerHeight - 0  then
			touchingLeftWall = true
        elseif enabled and normal.x < -wallThreshold and testY < actor:GetPosition().y + playerHeight - 0 then
			touchingRightWall = true
        end
		
		--if enabled and normal.x > wa
       
        return enabled
end
 
function RayCastCallback( normalVec, point, fraction )
	rcFraction = fraction
	rcNormal.x = normalVec.x
	rcNormal.y = normalVec.y
	rcPoint.x = point.x
	rcPoint.y = point.y

	rcCount = rcCount + 1
end
 
function Message( sender, msg, tag )
		
	if msg == "spikekill" then
		killed = true
		--die, respawn should probably be part of the c++ code
	elseif msg == "willdropthrough" then
		if currentInput:Down() then
			if not grounded or currentInput.A then
				return 0
			end
				--to drop through a platform you'd want to enable a special animation
		else
			return 1
		end
	elseif msg == "dropthrough" then
		trueGrounded = false
		lastGrounded = false
		dropThrough = true
	elseif msg == "dropthroughleft" then
		if currentInput:Left() and currentInput:Down() then
			trueGrounded = false
			lastGrounded = false
			return 1
		end
	elseif msg == "dropthroughright" then
		if currentInput:Right() and currentInput:Down() then
			trueGrounded = false
			lastGrounded = false
			return 1
		end
	elseif msg == "groundlock" then
		groundLockActor = sender
	elseif msg == "launchx" then
		specialVel.x = tag
	elseif msg == "launchy" then
		specialVel.y = specialVel.y + tag
	elseif msg == "carryx" then
		carryVel.x = carryVel.x + tag
	elseif msg == "carryy" then
		carryVel.y = carryVel.y + tag
   
	elseif msg == "unground" then
		grounded = false
		lastGrounded = false
		trueGrounded = false
	elseif msg == "dj" then
		if tag == 0 then
				hasDoubleJump = false
		elseif tag > 0 then
				hasDoubleJump = true
		end
	elseif msg == "ad" then
		if tag == 0 then
				hasAirDash = false
		elseif tag > 0 then
				hasAirDash = true
		end
	elseif msg == "gs" then
		if tag == 0 then
				hasGravitySlash = false
		elseif tag > 0 then
				hasGravitySlash = true
		end
	elseif msg == "air" then
		--will force the player to not ground for a number of frames
		forcedAirCounter = tag
		
		SetAction( jump )
		actionChanged = false
		frame = 3
	elseif msg == "canInterruptJump" then
		if tag == 0 then
				canInterruptJump = false
		elseif tag > 0 then
				canInterruptJump = true
		end
	elseif msg == "reflector" then
		reflector = true
	elseif msg == "tether_destroyed" then
		--damaged or meter damaged?
		tetherOn = false
	elseif msg == "tether_damage" then
		actor.health = actor.health - tag
		if actor.health <= 0 then
			killed = true
		end
	end
   
   
	return 0
	--print( "message: " .. msg )
end
 
function Die()
       
end

function SaveState()

	save_reflector = reflector
	
	save_lastGrounded = lastGrounded
	save_grounded = grounded
	save_killed = killed
	
	save_rcFraction = rcFraction
	save_rcPointX = rcPoint.x
	save_rcPointY = rcPoint.y
	save_rcNormalX = rcNormal.x
	save_rcNormalY = rcNormal.y
	save_rcCount = rcCount
	
	save_rampSlopeAdjust = rampSlopeAdjust
	
	save_hitlagVelSet = hitlagVelSet
	save_hitlagVelX = hitlagVel.x
	save_hitlagVelY = hitlagVel.y
   
	--specialVel.x = 0
	--specialVel.y = 0
   
	--specialAcc.x = 0
	--specialAcc.y = 0
   
	save_oldGroundNormalX = oldGroundNormal.x
	save_oldGroundNormalY = oldGroundNormal.y
   
	save_carryVelX = carryVel.x
	save_carryVelY = carryVel.y
   
	save_airControlLock = airControlLock
	
	save_groundLockActor = groundLockActor
   
	save_wallStop = wallStop
	--groundNormal.x = 0
	--groundNormal.y = 0
   
	save_slopeSlow = slopeSlow
	save_slopeAccel = slopeAccel
	save_trueGrounded = trueGrounded
   
   
	save_forcedAirCounter = forcedAirCounter
	
	save_canInterruptJump = canInterruptJump
	save_grav = grav
	
	save_framesInAir = framesInAir
	
	save_actorRightWallJump = actorRightWallJump
	save_actorLeftWallJump = actorLeftWallJump
	
	save_lastAction = lastAction
	save_touchingRightWall = touchingRightWall
	save_touchingLeftWall = touchingLeftWall
	
	save_prevPositionX = prevPosition.x
	save_prevPositionY = prevPosition.y
	
	save_angle = angle
	
	save_prevVelocityX = prevVelocity.x
	save_prevVelocityY = prevVelocity.y
	
	save_playerWidth = playerWidth
	save_playerHeight = playerHeight
	save_centerOffsetX = centerOffsetX 
	
	save_prevAction = prevAction
	save_prevFrame = prevFrame
	save_frame = frame
	save_action = action
	save_pos_x = actor:GetPosition().x
	save_pos_y = actor:GetPosition().y
	save_vel_x = actor:GetVelocity().x
	save_vel_y = actor:GetVelocity().y
	
	save_hasGravitySlash = hasGravitySlash
	save_gravityReverseCounter = gravityReverseCounter
	
	save_hasAirDash = hasAirDash
	save_airDashingRight = airDashingRight
	
	save_framesDashing = framesDashing
	
	save_hasDoubleJump = hasDoubleJump
	
	save_dropThrough = dropThrough
	
	save_hitlagFrames = hitlagFrames
	save_invincibilityFrames = invincibilityFrames    

end

function LoadState()    
	reflector = save_reflector 
	
	lastGrounded = save_lastGrounded 
	grounded = save_grounded 
	killed = save_killed 
	
	rcFraction = save_rcFraction 
	
	rcPoint.x = save_rcPointX 
	rcPoint.y = save_rcPointY 
	rcNormal.x = save_rcNormalX 
	rcNormal.y = save_rcNormalY 
	rcCount = save_rcCount
	
	rampSlopeAdjust = save_rampSlopeAdjust 
	
	hitlagVelSet = save_hitlagVelSet 
	hitlagVel.x = save_hitlagVelX 
	hitlagVel.y = save_hitlagVelY 
   
	--specialVel.x 0
	--specialVel.y 0
   
	--specialAcc.x 0
	--specialAcc.y 0
   
	oldGroundNormal.x = save_oldGroundNormalX 
	oldGroundNormal.y = save_oldGroundNormalY 
   
	carryVel.x = save_carryVelX 
	carryVel.y = save_carryVelY 
   
	airControlLock = save_airControlLock 
	
	groundLockActor = save_groundLockActor 
   
	wallStop = save_wallStop 
	--groundNormal.x 0
	--groundNormal.y 0
   
	slopeSlow = save_slopeSlow 
	slopeAccel = save_slopeAccel 
	trueGrounded = save_trueGrounded
   
   
	forcedAirCounter = save_forcedAirCounter 
	
	canInterruptJump = save_canInterruptJump 
	grav = save_grav 
	
	framesInAir = save_framesInAir 
	
	actorRightWallJump = save_actorRightWallJump 
	actorLeftWallJump = save_actorLeftWallJump 
	
	lastAction= save_lastAction 
	touchingRightWall = save_touchingRightWall
	touchingLeftWall = save_touchingLeftWall 
	
	prevPosition.x = save_prevPositionX 
	prevPosition.y = save_prevPositionY 
	
	angle = save_angle 
	
	prevVelocity.x = save_prevVelocityX 
	prevVelocity.y = save_prevVelocityY 
	
	playerWidth= save_playerWidth 
	playerHeight = save_playerHeight 
	centerOffsetX  = save_centerOffsetX 
	
	prevAction = save_prevAction 
	prevFrame = save_prevFrame 
	frame = save_frame 
	action = save_action 
	
	
	hasGravitySlash = save_hasGravitySlash 
	gravityReverseCounter = save_gravityReverseCounter 
	
	hasAirDash = save_hasAirDash 
	airDashingRight = save_airDashingRight 
	
	framesDashing = save_framesDashing 
	
	hasDoubleJump = save_hasDoubleJump 
	
	dropThrough = save_dropThrough 
	
	hitlagFrames = save_hitlagFrames 
	invincibilityFrames = save_invincibilityFrames 
end



function Sword( xOffset, yOffset, xSize, ySize )
	local a = angle-- * 3.5
    local c = math.cos( a )
    local s = math.sin( a )
	if actor:IsFacingRight() then
			actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, xOffset * c - yOffset * s, xOffset * s + yOffset * c, xSize, ySize, a )
	else
			actor:CreateBox( hitboxTypes.Slash, Layer_PlayerHitbox, -xOffset * c - yOffset * s, -xOffset * s + yOffset * c, xSize, ySize, a )
	end
end

trailCount = 0