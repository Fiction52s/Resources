--returns a bool whether the collision should be enabled or not
function HandleCollision( tileID, actor, tileVec, fractionVec, normalVec )
	enable = true
	consumed = true
	
	--if tileID == 10 or tileID == 11 or tileID == 12 then
	if tileID == 12 then--or tileID == 11 or tileID == 10 then
		test = actor:GetWorldBottom() - ( tileVec.y + fractionVec.y )
		--print( "test: " .. actor:GetWorldBottom() .. ", " .. ( tileVec.y + fractionVec.y ) )
		--if actor:GetVelocity().y <= 0 then
		--	print( "disabled:" .. normalVec.x .. ", " .. normalVec.y .. ",   " .. actor:GetVelocity().y )
			--enable = false
			
		--else
		--	print( "enabled: " .. normalVec.x .. ", " .. normalVec.y .. ",   " .. actor:GetVelocity().y )
			
		--end
		
		if actor:GetWorldBottom() - .02 >= tileVec.y + fractionVec.y or actor:GetVelocity().y < 0 and normalVec.y < 0 then 
			enable = false
			--print( "not enabled" )
		else
			local f = actor:Message( nil, "dropThroughGround", 0 )
			if f == 0 then
				enable = false
			end
			--print( "f: " .. f )
			--print( "platform" )
		end
		
	end
	
	--if tileID == 11 or tileID == 10 then
	--	actor:SetAngle( 0 )
	--end
		
	--print( "normal: " .. normalVec.x .. ", " .. normalVec.y )
	--if normalVec.y <= -.5 and actor:GetVelocity().y > 0 then
	--	actor:GetVelocity().y = 0
	--end
	return consumed, enable
end

--function HandleCollisionPost( actor, 

function HandleRayCast( tileID, actor, tileVec, collisionVec, normalVec )
	return true
end

function ModifyWorld( actor, tileVec, fractionVec, normalVec, enabled )
	--if normalVec
		
end

function UpdatePostPhysics()
	solidGround = false
end