-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
-- This is overriding TokenManager.updateSizeHelper() so we can dispaly the reach indication for player-controlled NPCs.
-- Intentionally copy as little as possible to reduce the chance of updates in the CoreRPG implementartion from breaking
-- this extension.
--

local updateSizeHelperOriginal;

function onInit()
    updateSizeHelperOriginal = TokenManager.updateSizeHelper;
	TokenManager.updateSizeHelper = updateSizeHelper;
end


function updateSizeHelper(tokenCT, nodeCT)

    -- Call CoreRPG version to get original functionality
    updateSizeHelperOriginal(tokenCT, nodeCT);

    -- Now that the CoreRPG update is done, we add the NPC hover for reach if it is a player-controlled NPC

    -- This math calculation is copied from CoreRPG updateSizeHelper() in manager_token.lua.
    -- If the CoreRPG implementation changes, this math will likely have to change as well.

	local nDU = GameSystem.getDistanceUnitsPerGrid();
	
	local nSpace = math.ceil(DB.getValue(nodeCT, "space", nDU) / nDU);
	local nHalfSpace = nSpace / 2;
	local nReach = math.ceil(DB.getValue(nodeCT, "reach", nDU) / nDU) + nHalfSpace;

	-- Reach underlay
	local sClass, sRecord = DB.getValue(nodeCT, "link", "", "");

	if FriendZone.isCohort(sRecord) and sClass == "npc" then
        tokenCT.addUnderlay(nReach, "4f000000", "hover");
    end
end
