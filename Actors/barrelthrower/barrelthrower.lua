function SpriteCount()
	return 1
end

function BodyType()
	return false, 2
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	
--	print( "barrelthrowing init start" )
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
	
	spriteAngle = angle
	angle = spriteAngle * math.pi	
	
	--move specific/initialize animations--
	barrelSet = actor:TileSetIndex( "barrel.png" )
	
	oldPos = ACTOR:b2Vec2()
	oldPos.x = actor:GetPosition().x
	oldPos.y = actor:GetPosition().y
	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { barrelSet, 0}
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
	--actor:CreateCircle( 12, Layer_PlayerDetection, 0, 0, 30 )
	
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .93, 1.56, 0 ) 
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .93, 1.56, 0 ) 
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .93, 1.56 , 0 )
	
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, 1 )
	
	--actor:SetVelocity( 10, 0 )
	
  --actor:ClearHurtboxes()
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .5, .5, 0 ) 
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .5, .5, 0 ) 
	actor:SetFriction( 0 )

	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .5, 1.5, 0 ) 
	SetAction( exist )

	
	actor:SetSpriteEnabled( 0, true )
	
	waitToFire = 120
	framesWaited = 0
	
	print( "barrelthrowing init over" )
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

print( "a" )
	local aPos = actor:GetPosition()
	local offsetX = 1
	aPos.y = aPos.y - 1
	local aVel = ACTOR:b2Vec2()
	local velX = 10
	local velY = 5
	if actor:IsFacingRight() then
		aPos.x = aPos.x + offsetX
		aVel.x = velX
		aVel.y = -velY
	else
		aPos.x = aPos.x - offsetX
		aVel.x = -velX
		aVel.y = -velY
	end
	
	print( "b" )
	if framesWaited >= waitToFire then
		stage:CreateActor( "barrel", aPos, aVel, actor:IsFacingRight(), false, 0, actor )
		framesWaited = 0
	end
	print( "c" )
	
	--surroundingActors = 0
	--print( "updating" )
	
	if slowCounter == 0 then
	actionChanged = false
	actor:ClearActorsAttacked()
	ActionEnded()
	ChooseAction()
	HandleAction()

	
	end
	
	if slowFactor ~= 1 then
		actor:SetVelocity( actor:GetVelocity().x / slowFactor, actor:GetVelocity().y / slowFactor )
		oldSlowFactor = slowFactor
		slowFactor = 1
	end
	
	actor:SetFriction( 0 )
	
	actor:SetSpriteAngle( 0, spriteAngle )
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
	--actor:SetSpriteAngle( angle ) 
	
end

function UpdatePostPhysics()
	slowCounter = slowCounter + 1
	if slowCounter >= slowFactor then
		frame = frame + 1
		slowCounter = 0
		framesWaited = framesWaited + 1
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
	
	
	
	return false
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
