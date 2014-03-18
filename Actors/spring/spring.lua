function SpriteCount()
	return 1
end

function BodyType()
	return true, 0
	--static body: 0
	--kinematic body: 1
	--dynamic body : 2
end

function Init()
	--note: 1 is the first index in Lua, not 0
	
	player = stage.player
	spriteAngle = angle
	angle = spriteAngle * math.pi	
	
	power = 60
	springFrames = 20
	thrownActor = nil
	
	action = exist
	--print( "initializing" )
	
	--move specific/initialize animations--
--	lobber1Set = actor:TileSetIndex( "lobber1.png" )
	springSet = actor:TileSetIndex( "spring.png" )
	
	actor:SetSpriteEnabled( 0, true )
	--testAirAttack = {}
	--for i = 1, 15 do
	--	testAirAttack[i] = {doubleJumpSet, 10 }
	--end
	
	exist = {}
	for i = 1, 2 do
		exist[i] = { springSet, 0}
	end
	
	throw = {}
	for i = 1, springFrames do
		throw[i] = { springSet, 0 }
	end

	
	--contact types--
	bodyTypes = {Normal = 1}
	bodyStrings = {"Normal"}
	hitboxTypes = {Heal = 1, Slash = 2}
	hitboxStrings = {"Heal", "Slash"}
	
	--init state

	frame = 1
	
	actor:SetVelocity( 0, 0 )
	--might have this in the update to grow each frame later
	--actor:ClearDetectionboxes()
	--actor:CreateCircle( 12, Layer_PlayerHitbox, 0, 0, 4 )
	
	actor:CreateBox( 4, Layer_PlayerDetection, .5 * math.sin( angle ), -.5 * math.cos( angle ), 1.3, .3, angle ) 
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyHitbox, -currentHeight * math.sin(angle), currentHeight * math.cos( angle ), .35 * ( 1 - currentHeight - maxHeight ), .7 , angle) 

	actor:SetFriction( 0 )
	SetAction( exist )
	
	--actor:CreateBox( bodyTypes.Normal, Layer_EnemyPhysicsbox, 0, 0, .5, 1, 0 ) 
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
		if action == throw then
			--thrownActor:Message( actor, "launchy", power )
			SetAction( exist )
			frame = 1
		else
			frame = 1
		end
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
	
	
	if throwActor and action ~= throw then
		SetAction( throw )
		frame = 1
		throwActor = false
		
		--print( "Setaction( throw )" )
		--otherActor:SetVelocity( otherActor:GetVelocity().x, 0 )
	elseif throwActor then
		throwActor = false
	end
	
	
	
	actor:SetSprite( 0, action[frame][1], action[frame][2] )
	actor:SetSpriteAngle( 0, spriteAngle )
end

function UpdatePostPhysics()
	--if action == throw then
	  --if action == throw and 
	  if throwActor and action ~= throw then
		--if frame == 1 then
			--thrownActor:Message( actor, "unground", 0 )
			if thrownActor:GetVelocity().y > 0 then
				truePower = math.max( power + thrownActor:GetVelocity().y, power )
			else 
				truePower = power + thrownActor:GetVelocity().y
			end
			--thrownActor:Message( actor, "launchy", -truePower )
			--print( "truepower: "  .. truePower )
			local x = --thrownActor:GetVelocity().x * math.cos(angle) + thrownActor:GetVelocity().y * math.sin( angle ) + 60 * math.sin(angle)
			60 * math.sin(angle) + thrownActor:GetVelocity().x * math.cos( angle )
			local y = --thrownActor:GetVelocity().x * math.sin(angle) + thrownActor:GetVelocity().y * math.cos( angle ) - 60 * math.cos( angle )
			-60 * math.cos(angle) --+ thrownActor:GetVelocity().y * math.sin( angle )
			--thrownActor:SetVelocity( thrownActor:GetVelocity().x, -60 )
			local s = math.sin( angle )
			local c = math.cos( angle )
			
			
			--if s >= 0 then
			if 60 * s > 0 and thrownActor:GetVelocity().x * c > 0 or 60 * s < 0 and thrownActor:GetVelocity().x * c < 0 then
				x = 60 * s
			end
			
			if -60 * c > 0 and thrownActor:GetVelocity().y * s > 0 or -60 * c < 0 and thrownActor:GetVelocity().y * s < 0 then
				y = -60 * c
				print( "y mod" )
			end
			--if x > 60 then x = 60 end
			--if x < -60 then x = -60 end
			--if y > 60 then y = 60 end
			--if y < -60 then y = -60 end
			
			print( "throwing at: " .. x .. ", " .. y .. " at angle " .. angle .. ", s: " .. s .. ", c: " .. c )
			thrownActor:SetVelocity( x, y )
			thrownActor:Message( actor, "dj", 1 )
			thrownActor:Message( actor, "ad", 1 )
			thrownActor:Message( actor, "gs", 1 )
			thrownActor:Message( actor, "air", 10 )
			thrownActor:Message( actor, "canInterruptJump", 0 )
			
			--print( "yeah" )
			--thrownActor:SetPosition( thrownActor:GetPosition().x, 
			--otherActor:SetVelocity( otherActor:GetVelocity().x, 0 )
		--elseif frame == 2 then
			--thrownActor:Message( actor, "launchy", truePower )
		--end
		
		if frame < 5 then
			--thrownActor:Message( actor, "unground", 0 )
		end
		
		
		
	end
	
	if throwActor and action ~= throw then
		--thrownActor:SetPosition( actor:GetPosition().x + .75 * math.sin( angle ), actor:GetPosition().y -.75 * math.cos( angle ) )
		thrownActor:SetPosition( thrownActor:GetPosition().x, actor:GetPosition().y -.75 * math.cos( angle ) )
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
function CollideWithActor( otherActor, tag )
	if tag == 4 then
		throwActor = true
		thrownActor = otherActor
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
	
	return 0
end

function Die()
	
end
