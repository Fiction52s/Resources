--returns a bool whether the collision should be enabled or not

function HandleCollision( tileID, actor, tileVec, collisionVec, normalVec )
	local enable = true
	local consumed = true
	
	--25-28
	if tileID == 12 or tileID == 25 or tileID == 26 then
		--local f = actor:Message( nil, "dropthroughleft", 0 )
		--if f == 1 then
		--	enable = false
		--end
	end
	
	if tileID == 13 or tileID == 27 or tileID == 28 then
		--local f = actor:Message( nil, "dropthroughright", 0 )
		--if f == 1 then
		--	enable = false
		--end
	end
	
	
	if tileID == 12 then 
		if actor:GetVelocity().y < 0 and actor:GetVelocity().x >= 0 then
			--enable = false
		end
		local testX = actor:GetWorldLeft() - tileVec.x
		local testY = actor:GetWorldBottom() - tileVec.y
		--if testY > testX then enable = false end
		
		if actor:GetWorldBottom() - 02 > tileVec.y + 1 and actor:GetWorldLeft() > tileVec.x then
		--if actor:GetWorldBottom() - .02 > tileVec.y + 1 then--- ( actor:GetPosition().x - tileVec.x ) then
			--enable = false
		end
	end
	--if tileID == 10 or tileID == 11 or tileID == 12 then
	if tileID >= 38 and tileID <= 41 then--or tileID == 11 or tileID == 10 then
		--test = actor:GetWorldBottom() - ( tileVec.y + fractionVec.y )
		--print( "test: " .. actor:GetWorldBottom() .. ", " .. ( tileVec.y + fractionVec.y ) )
		--if actor:GetVelocity().y <= 0 then
		--	print( "disabled:" .. normalVec.x .. ", " .. normalVec.y .. ",   " .. actor:GetVelocity().y )
			--enable = false
			
		--else
			--print( "enabled: " .. normalVec.x .. ", " .. normalVec.y .. ",   " .. actor:GetVelocity().y )
			
		--end
		
		-- .02
	--	enable = false
		--print( tileID .. ": " .. tileVec.x .. ", " .. tileVec.y )
		if actor:GetVelocity().y < 0 or actor:GetWorldBottom() - .02 > tileVec.y + 1 then
		--if actor:GetWorldBottom()  >= tileVec.y + 1 then
			enable = false
		--	print( "NO ENABLE" )
			--print( "not enabled" )
			--dropThrough = true
			--enable = true
			
			--print( "f: " .. f )
			--print( "platform" )
		else
			local f = actor:Message( nil, "willdropthrough", 0 )
			if f == 0 then
				if actor:GetVelocity().y <= 2 and not solidGround then
					actor:Message( nil, "dropthrough", 0 )
				end
				enable = false
				--dropThrough = true
			else

			end
		end
		--else
			
		--end
		
		if enable then
			--print( "missed" )
		end
	else
		solidGround = true
		--print( "enable" )
		--print( "fdfsfsdfsdfs: " .. tileID )
	end
	
	if tileID == 105 or tileID == 91 or tileID == 104 or tileID == 118 then
		--print( "i hit the spikes")
		if actor.type == stage.player.type then
			--actor:Kill() --send message spike kill
			actor:Message( nil, "spikekill", 0 )
		end
	end
	--print( "tileID: " .. tileID )
	--print( "bottom: " .. actor:GetWorldBottom() )
	--print( "norm: " .. normalVec.x .. ", " .. normalVec.y )
	--if tileID == 11 or tileID == 10 then
	--	actor:SetAngle( 0 )
	--end
		
	--print( "normal: " .. normalVec.x .. ", " .. normalVec.y )
	--if normalVec.y <= -.5 and actor:GetVelocity().y > 0 then
	--	actor:GetVelocity().y = 0
	--end
	consumed = false
	return consumed, enable
end

function HandleRayCast( tileID, actor, tileVec, collisionVec, normalVec )
	--if tileID == 12 then
		--local f = actor:Message( nil, "dropthroughleft", 0 )
		--if f == 1 then
		--	return false
		--end
		--local testX = actor:GetWorldLeft() - tileVec.x
		--local testY = actor:GetWorldBottom() - tileVec.y
		--if testY > testX then return false end
	--end
	
	
	--for player only
	if actor.type == stage.player.type then
		if tileID >= 38 and tileID <= 41 then
			if --[[actor:GetVelocity().y < 0 or --]] actor:GetWorldBottom() - .02 > tileVec.y + 1 or (actor:Message(nil, "willdropthrough", 0 ) == 0 and actor:GetVelocity().y > 2 ) then
				--print( "vel: " .. actor:GetVelocity().y .. ", norm: " .. normalVec.y )
				--print( "Result: " .. actor:GetVelocity().y * math.abs( normalVec.y ) )
				return false
			end
			
			--local f = actor:Message( nil, "dropThroughGround", 0 )
				if f == 0 then
					
				--	return false
					--dropThrough = true
				end
		end
	end
	--print( "handle" )
	return true
end
--function HandleCollisionPost( actor, 

function ModifyWorld( actor, tileVec, fractionVec, normalVec, enabled )
	--if normalVec
	--dropThrough = false
end

function UpdatePostPhysics()
	solidGround = false
end