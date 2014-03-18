function SpriteCount()
	return 1
end

function BodyType()
	return true, 2
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	surroundingActors = 0
	player = stage.player
	health = 100
	sightDistanceActive = 40
	sightDistanceNeutral = 9
	speed = .5--1
	active = false
	initializing = false
	alive = false
	groundNormal = ACTOR:b2Vec2()
	groundNormal.x = 0
	groundNormal.y = -1
	framesRunning = 0
	activated = false
	lastGrounded = false
	--existing = false
	--print( "initializing" )
	
	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	--move specific/initialize animations--
	blueSquareSet = actor:TileSetIndex( "runner1.png" )
	
	oldPos = ACTOR:b2Vec2()
	oldPos.x = actor:GetPosition().x
	oldPos.y = actor:GetPosition().y
	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { blueSquareSet, 0}
	end
	
	maxVelocity = ACTOR:b2Vec2()
	maxVelocity.x = 20
	--maxVelocity.x = 15
	maxVelocity.y = 40
	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Heal = 1, Slash = 2}
	hitboxStrings = {"Heal", "Slash"}
	
	--init state

	frame = 1
	
	actor:SetVelocity( 0, 0 )
	--this will eventually be replaced with createBoxes ONLY IN UPDATE for each action, if the box changes during a dash or w.e.
	--actor:ClearHurtboxes()
	actor:CreateCircle( 12, Layer_PlayerDetection, 0, 0, 30 )
	
--	
  --actor:ClearHurtboxes()
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .5, .5, 0 ) 
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .5, .5, 0 ) 
	actor:SetFriction( 0 )
	airSpeed = 1
	maxAirSpeed = 10
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .5, 1.5, 0 ) 
	SetAction( exist )
	
	actor:SetSpriteEnabled( 0, true )
end

function GetAttackType( i )
	return hitTypes[i]
end

function Heal( otherActor )
	--print( "gotcha" )
	--print( "I am healing you" )
end

function Slash( otherActor )
	--print( "slashing" )
end

function ActionEnded()
	if frame > #action then 
		frame = 1
		--else
		--	action = nil
		--	frame = 0 --not sure if this ever comes into play
		--end
	end
end

function CancelAction()
	--here you would cancel any effects created by actions which are being canceled
end

function ChooseAction()
	--print( "srsly here guys" )
end

function HandleAction()

end

function UpdatePrePhysics()	

	
	--surroundingActors = 0
	--print( "updating" )
	if initializing then
		actor:ClearDetectionboxes()
		actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .93, 1.56, 0 ) 
		actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .93, 1.56, 0 ) 
		actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .93, 1.56 , 0 )
		--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, 1, 1, 0 ) 
		--actor:CreateCircle( 11, Layer_ActorDetection, 0, 0, 3 )
		initializing = false
		alive = true
		
		if player:GetPosition().x < actor:GetPosition().x then
			actor:FaceLeft()
		else
			actor:FaceRight()
		end
	end
	
	if not alive then
		return
	end
	
	if slowCounter == 0 then
	actionChanged = false
	actor:ClearActorsAttacked()
	ActionEnded()
	ChooseAction()
	HandleAction()
	--print( "i swear im alive guys" )
	
	lastJumpNow = jumpNow
	
	if grounded and jumpNow then
		actor:SetVelocity( actor:GetVelocity().x, -30 )
		grounded = false
		jumpNow = false
		framesRunning = 0
	end
	
	if not grounded then
		if actor:IsFacingRight() then
			actor:SetVelocity( actor:GetVelocity().x + airSpeed, actor:GetVelocity().y )
		else 
			actor:SetVelocity( actor:GetVelocity().x - airSpeed, actor:GetVelocity().y )
		end
		
		if actor:GetVelocity().x > maxAirSpeed then
			actor:SetVelocity( maxAirSpeed, actor:GetVelocity().y )
		elseif actor:GetVelocity().x < -maxAirSpeed then
			actor:SetVelocity( -maxAirSpeed, actor:GetVelocity().y )
		end
	end
	
	
	--framesRunning = framesRunning + 1
	--if framesRunning > 60 then
	if grounded then
		if math.abs( actor:GetVelocity().x ) > maxVelocity.x - 5 and player:GetPosition().x > actor:GetPosition().x and not actor:IsFacingRight() then
			actor:FaceRight() 
			--jumpNow = true
			--actor:SetVelocity( actor:GetVelocity().x / 2, actor:GetVelocity().y / 2 )
		--	framesRunning = 0
		elseif math.abs( actor:GetVelocity().x ) > maxVelocity.x - 5 and player:GetPosition().x < actor:GetPosition().x and actor:IsFacingRight() then
			actor:FaceLeft()
			--jumpNow = true
			--actor:SetVelocity( actor:GetVelocity().x / 2, actor:GetVelocity().y / 2 )
		--	framesRunning = 0
		end
	end
	
	if grounded and not lastGrounded then
		framesRunning = 0
	elseif grounded then
		framesRunning = framesRunning + 1
	end
	--if grounded and actor:GetPosition().y > player:GetPosition().y then
	--	jumpNow = true
	--end
	
	print( "vvv: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
	
	
	if grounded then
	if actor:IsFacingRight() then
		if actor:GetVelocity().x < 0 then
			actor:SetVelocity( actor:GetVelocity().x + speed / 2, actor:GetVelocity().y )
		else
			actor:SetVelocity( actor:GetVelocity().x + speed, actor:GetVelocity().y )
		end
		
	else
		if actor:GetVelocity().x < 0 then
			actor:SetVelocity( actor:GetVelocity().x - speed / 2, actor:GetVelocity().y )
		else
			actor:SetVelocity( actor:GetVelocity().x - speed, actor:GetVelocity().y )
		end
	end
	else
		if actor:IsFacingRight() then
			--actor:SetVelocity( actor:GetVelocity().x + speed, actor:GetVelocity().y )
		else
			--actor:SetVelocity( actor:GetVelocity().x - speed, actor:GetVelocity().y )
		end
	end
	
	
	if grounded then
	if ( actor:GetVelocity().x > 0 and groundNormal.x < 0 ) or ( actor:GetVelocity().x < 0 and groundNormal.x < 0 ) then
			actor:SetVelocity( actor:GetVelocity().x, -actor:GetVelocity().x * groundNormal.x / groundNormal.y )
	elseif ( actor:GetVelocity().x > 0 and groundNormal.x > 0 ) or ( actor:GetVelocity().x < 0 and groundNormal.x > 0 ) then
		actor:SetVelocity( actor:GetVelocity().x, -actor:GetVelocity().x * groundNormal.x / groundNormal.y )
	else
		actor:SetVelocity( actor:GetVelocity().x, 0 )
	end
	end
	
	--grav
	grav = 1.5
	
	--if grounded then
	--	actor:SetVelocity( actor:GetVelocity().x - groundNormal.x * grav, actor:GetVelocity().y - groundNormal.y *  grav )
		
	--else
		actor:SetVelocity( actor:GetVelocity().x, actor:GetVelocity().y + grav )
		
	--end
	
	groundNormal.x = 0
	groundNormal.y = -1
	lastGrounded = grounded
	grounded = false
	
	print( "vvv22222: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
	
	if actor:GetVelocity().y > maxVelocity.y then
		actor:SetVelocity( actor:GetVelocity().x, maxVelocity.y )
	elseif actor:GetVelocity().y < -maxVelocity.y then
		actor:SetVelocity( actor:GetVelocity().x, -maxVelocity.y )
	end
	
	if actor:GetVelocity().x > maxVelocity.x then
		actor:SetVelocity( maxVelocity.x, actor:GetVelocity().y )
	elseif actor:GetVelocity().x < -maxVelocity.x then
		actor:SetVelocity( -maxVelocity.x, actor:GetVelocity().y )
	end
	print( "actor vel: " .. actor:GetVelocity().x .. ", " .. actor:GetVelocity().y )
	
	if actor:GetVelocity().x > 0 then
	--	actor:FaceRight()
	elseif actor:GetVelocity().x < 0 then
--		actor:FaceLeft()
	end
	
	end
	
	if slowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
		oldSlowFactor = slowFactor
		slowFactor = 1
	end
	
	leftWall = false
	rightWall = false
	
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
	--actor:SetSpriteAngle( angle ) 
	
end

function UpdatePostPhysics()
	slowCounter = slowCounter + 1
	if slowCounter >= slowFactor then
		frame = frame + 1
		slowCounter = 0
	end

	if oldSlowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x * oldSlowFactor, actor:GetVelocity().y * oldSlowFactor )
		oldSlowFactor = 1
	end
end

function SetAction( newAction )
	if action ~= nil then
		CancelAction()
	end
	if action ~= newAction then
		actionChanged = true
	end
	action = newAction
end

--for when you hit something
function HitActor( otherActor, hitboxTag )
	if hitboxTag == hitboxTypes.Heal then
	--	print( "testing blah" )
	end 
	
	return hitboxStrings[hitboxTag], 10, 10, 0, 0
	--return type, damage, hitlag, hitstun
end

function ConfirmHit( otheractor, hitboxName, damage, hitlag, xx )
        --hitlagFrames = hitlag
        --actor:SetVelocity( 0, 0 )
end

--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, xhitstun, hurtboxTag, hitboxCenterX )
	--print( "hit by actor with hitboxName " .. hitboxName )
	health = health - damage
	--print( "runner health: " .. health )
	if health <= 0 then
		actor:Kill()
	end
	
	return true
end

--when you collide with some Actor
function CollideWithActor( otherActor, tag )
	if tag == 12 then
		--print( "collide" )
		--initializing = true
	elseif tag == 11 and otherActor.type ~= player.type then
		--surroundingActors = surroundingActors + 1
		--print( "plus 1" )
	end
	--print( "collide" )

	
	return false, true
	--enable then active
	--returns a bool for whether this should count or not
end

--not sure if this is necessary yet
function HandleActorCollision( posX, posY, otherActor )
end

function HandleStageCollision( pointCount, point1, point2, normal, enabled )
	if enabled and normal.y < -.5 and not lastJumpNow then
		groundNormal.x = normal.x
		groundNormal.y = normal.y
		grounded = true
	end

	
	
	if normal.x < -.9 and enabled and actor:IsFacingRight() then
		rightWall = true
	elseif normal.x > .9 and enabled and not actor:IsFacingRight() then
		leftWall = true
	end
	
	if rightWall and player:GetPosition().x < actor:GetPosition().x then 
		actor:FaceLeft()
		
		--stage:CreateActor( "runner1", actor:GetPosition().x -1, actor:GetPosition().y, 0, 0, actor:IsFacingRight(), false, actor )
		--stage:CreateActor( "runner1", actor:GetPosition().x + .2, actor:GetPosition().y, 0, 0, actor:IsFacingRight(), false, actor )
		--stage:CreateActor( "runner1", actor:GetPosition().x + .3, actor:GetPosition().y, 0, 0, actor:IsFacingRight(), false, actor )
		
	elseif leftWall and player:GetPosition().x > actor:GetPosition().x then 
		actor:FaceRight() 
	elseif grounded and (rightWall or leftWall ) then
		jumpNow = true
	end
	
	if grounded and actor:GetPosition().y > player:GetPosition().y and framesRunning > 60 then
	--	jumpNow = true
		print( "this jump: " .. framesRunning  )
	end
	
	
	
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
--actor/stage, string message, int tag
	--print( "message: " .. msg )
	if msg == "activate" then
		initializing = true
	end
	if msg == "slow" then
		slowFactor = tag
	end
	return 0
end

function Die()
	
end
