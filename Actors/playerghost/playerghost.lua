function SpriteCount()
	return 0
end

function BodyType()
        return true, 0
		
		--fixed angle true or false,
        --static body: 0
        --kinematic body: 1
        --dynamic body : 2
end
 
function Init()
        --contact types--
        bodyTypes = {Normal = 1}
        bodyStrings = {"Normal"}
        hitboxTypes = {Heal = 1, Slash = 2}
        hitboxStrings = {"Heal", "Slash"}
       


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

 

 
 function Spawn()

 end
 
 
--for when you hit something
function HitActor( otherActor, hitboxTag )
        --if hitboxTag == hitboxTypes.Heal then
                --print( "testing blah" )
        --end
        --5
        --return hitboxStrings[hitboxTag], 10, 3, 0, 0
		return "blah", 10, 3, 0, 0
        --return type, damage, hitlag, hitstun, centerX (relative to this actor)
end
 
function ConfirmHit( otheractor, hitboxName, damage, hitlag, xx )
		if hitlagFrames == 0 then
			
		else
			--hitlagFrames = hitlagFrames + 1
		end
		hitlagFrames = hitlag
		
		
		if hitlagFrames > 0 and not hitlagVelSet then
			hitlagVel.x = actor:GetVelocity().x
			hitlagVel.y = actor:GetVelocity().y
			actor:SetVelocity( 0, 0 )
			hitlagVelSet = true
		end
end