-- 
-- Please see the license.txt file included with this distribution for 
-- attribution and copyright information.
--

local getActorRecordTypeFromPathOriginal;

function onInit()
	getActorRecordTypeFromPathOriginal = ActorManager.getActorRecordTypeFromPath;
	ActorManager.getActorRecordTypeFromPath = getActorRecordTypeFromPath;
end

function getActorRecordTypeFromPath(sActorNodePath)
	local result = getActorRecordTypeFromPathOriginal(sActorNodePath);
	if (not result) or (result == "charsheet") then
		if sActorNodePath:match("%.cohorts%.") then
			result = "npc";
		elseif sActorNodePath:match("%.units%.") then
			result = "unit";
		end
	end
	return result;
end
