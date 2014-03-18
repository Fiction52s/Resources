--returns a bool whether the collision should be enabled or not

function HandleCollision( tileID, actor, tileVec, collisionVec, normalVec )
	local enable = true
	local consumed = true
	
	if actor.type == stage.player.type then
		actor:Message( nil, "reflector", 0 )
	end

	return consumed, enable
end

function HandleRayCast( tileID, actor, tileVec, collisionVec, normalVec )
	return true
end
--function HandleCollisionPost( actor, 

function ModifyWorld( actor, tileVec, fractionVec, normalVec, enabled )
	--if normalVec
	--dropThrough = false
end

function UpdatePostPhysics()
end