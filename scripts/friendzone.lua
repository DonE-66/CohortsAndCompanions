-- 
-- Please see the license.txt file included with this distribution for 
-- attribution and copyright information.
--


function onInit()

end

function onClose()

end


function addCohort(nodeChar, nodeNPC)
	local nodeCohorts = nodeChar.createChild("cohorts");
	if not nodeCohorts then
		return;
	end

	local nodeNewCohort = nodeCohorts.createChild();
	if not nodeNewCohort then
		return;
	end

	DB.copyNode(nodeNPC, nodeNewCohort);
	DB.setValue(nodeNewCohort, "hptotal", "number", DB.getValue(nodeNewCohort, "hp", 0));
end


function isCohort(vRecord)
	local rActor = ActorManager.resolveActor(vRecord);
	if rActor and rActor.sCreatureNode and rActor.sCreatureNode:match("%.cohorts%.") then
		return true;
	end

	return false;
end
