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
	actor:SetSpriteEnabled( 0, true )
	player = stage.player
	
	framesToLive = 120 --frames to live
	slowFactor = 2
	--print( "initializing" )
	
	--move specific/initialize animations--
--	lobber1Set = actor:TileSetIndex( "lobber1.png" )
	timeWaveSet = actor:TileSetIndex( "timewave.png" )
	
	oldPos = ACTOR:b2Vec2()
	oldPos.x = actor:GetPosition().x
	oldPos.y = actor:GetPosition().y
	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 120 do
		exist[i] = { timeWaveSet, (i / 8) % 4}
	end
	
	maxVelocity = ACTOR:b2Vec2()
	maxVelocity.x = math.random( 10, 14 )
	--maxVelocity.x = 15
	maxVelocity.y = maxVelocity.x
	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Heal = 1, Slash = 2}
	hitboxStrings = {"Heal", "Slash"}
	
	--init state

	frame = 1
	
	actor:SetVelocity( 0, 0 )
	--might have this in the update to grow each frame later
	actor:ClearDetectionboxes()
	actor:CreateCircle( 12, Layer_ActorDetection, 0, 0, 4 )

	actor:SetFriction( 0 )
	SetAction( exist )
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
	
	if framesToLive % 40 == 0 then
		slowFactor = slowFactor + 1
	end
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
end

function UpdatePostPhysics()
	framesToLive = framesToLive - 1
	if framesToLive == 0 then 
		actor:Kill()
	end
	frame = frame + 1
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
	return 0, 0, 0, 0
	--return hitboxStrings[hitboxTag], 10, 0, 0
	--return type, damage, hitlag, hitstun
end

--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, hitstun, hurtboxTag )
end

--when you collide with some Actor
function CollideWithActor( otherActor, hurtboxTag )
	if hurtboxTag == 12 then
		--10
		otherActor:Message( actor, "slow", 8  )
		--print( "slowFactor: " .. slowFactor )
	end
	
	return false, false
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
	return 0
end

function Die()
	
end
