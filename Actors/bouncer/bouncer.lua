function SpriteCount()
	return 1
end

function BodyType()
	return 0
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	bouncedActors = {}
	player = stage.player
	
	framesToLive = 120 --frames to live
	slowFactor = 2
	--print( "initializing" )
	
	--move specific/initialize animations--
--	lobber1Set = actor:TileSetIndex( "lobber1.png" )
	bouncerSet = actor:TileSetIndex( "bouncer.png" )
	
	oldPos = ACTOR:b2Vec2()
	oldPos.x = actor:GetPosition().x
	oldPos.y = actor:GetPosition().y
	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { bouncerSet, 0}
	end
	
	maxVelocity = ACTOR:b2Vec2()
	maxVelocity.x = math.random( 10, 14 )
	--maxVelocity.x = 15
	maxVelocity.y = maxVelocity.x
	
	actor:SetSpriteEnabled( 0, true )
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
	actor:CreateBox( 1, Layer_ActorDetection, 0, 0, .2, 1, 0 )

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
	ActionEnded()
	
	for k,v in pairs(bouncedActors) do
		bouncedActors[k] = false
	end
	
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
end

function UpdatePostPhysics()
	for k,v in pairs(bouncedActors) do
		if v == false then	
			bouncedActors[k] = nil
		end
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
	return 0, 0, 0, 0, 0
	--return hitboxStrings[hitboxTag], 10, 0, 0
	--return type, damage, hitlag, hitstun
end

--for when you are hit by some Actor
function HitByActor( otherActor, hitboxName, damage, hitlag, hitstun, hurtboxTag )
end

--when you collide with some Actor
function CollideWithActor( otherActor, hurtboxTag )
	id = tostring(otherActor:GetUniqueID() )
	
	--if bouncedActors[otherActor] == nil then
	--bouncedActors[otherActor + ""] = 5
	--print( bouncedActors[otherActor + ""] )
	--	print( "other: " .. "nil" )
		--bouncedActors[4] = true
		
		--print( "other again: " .. bouncedActors[4] )
	--end
	if hurtboxTag == 1 and bouncedActors[id] == nil then
		--10
		otherActor:Message( actor, "switch", 0  )
		bouncedActors[id] = true
		--bouncedActors[otherActor] = true
		--table.insert( bouncedActors, {otherActor, true } )
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
