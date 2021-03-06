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
	player = stage.player
	health = 1
	active = false
	initializing = false
	alive = false
	die = false
	
	pullMode = false
	
	slowCounter = 0
	slowFactor = 1
	oldSlowFactor = 1
	
	spriteAngle = angle
	angle = spriteAngle * math.pi	
	
	--move specific/initialize animations--
	tetherSet = actor:TileSetIndex( "tether.png" )
	
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { tetherSet, 0}
	end
	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Heal = 1, Slash = 2}
	hitboxStrings = {"Heal", "Slash"}
	
	--init state

	frame = 1
	
	originalPos = ACTOR:b2Vec2()
	originalPos.x = actor:GetPosition().x
	originalPos.y = actor:GetPosition().y
	--this will eventually be replaced with createBoxes ONLY IN UPDATE for each action, if the box changes during a dash or w.e.
	--actor:ClearHurtboxes()
	actor:CreateCircle( 12, Layer_PlayerDetection, 0, 0, .5 )
	
--	actor:CreateBox( bodyTypes.Normal, Layer_EnemyHurtbox, 0, 0, .93, 1.56, 0 ) 
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, 0, 0, .93, 1.56, 0 ) 
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .93, 1.56 , 0 )
	
	--actor:CreateCircle( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, 1 )
	actor:CreateCircle( bodyTypes.Normal, Layer_PlayerHurtbox, 0, 0, .25 )
	--actor:CreateCircle( bodyTypes.Normal, Layer_PlayerHitbox, 0, 0, .5 )
	--actor:CreateCircle( 11, Layer_ActorDetection, 0, 0, 1 )
	
	
	
	
  

	
	SetAction( exist )
	
	actor:SetSpriteEnabled( 0, true )
	
	rightWall = false
	leftWall = false
	ceiling = false
	exploding = false
	
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
	
	actor:SetSpriteAngle( 0, actor:GetBodyAngle() )
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
end

function UpdatePostPhysics()
	slowCounter = slowCounter + 1
	if slowCounter >= slowFactor then
		frame = frame + 1
		slowCounter = 0
		
		if die then
			actor:Kill()
		end
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
	
	if not pullMode then
		health = health - damage
		--print( "runner health: " .. health )
		if health <= 0 then
			player:Message( actor, "tether_destroyed", 0 )
			actor:Kill()
		end
	else
		player:Message( actor, "tether_damage", damage )
	end
	
	return true
end

--when you collide with some Actor
function CollideWithActor( otherActor, tag )
	if tag == 12 then
		player:Message( actor, "tether_arrived", 0 )
		print( "TETHER _ ARRIVED" )
	end
	
	return false, true
	--enable then active
	--returns a bool for whether this should count or not
end

--not sure if this is necessary yet
function HandleActorCollision( posX, posY, otherActor )
end

function HandleStageCollision( pointCount, point1, point2, normal, enabled )
	enabled = false
	
	
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
	
	if msg == "explode" then
		die = true
	end
	if msg == "tether_pull" then
		pullMode = true
	end
	
	return 0
end

function Die()
	
end