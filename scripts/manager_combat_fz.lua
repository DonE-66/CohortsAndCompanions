-- 
-- Please see the license.txt file included with this distribution for 
-- attribution and copyright information.
--

local showTurnMessageOriginal;
local centerOnTokenOriginal;
local onNPCPostAddOriginal;
local addUnitOriginal;
local addCTANPCOriginal;

function onInit()
	showTurnMessageOriginal = CombatManager.showTurnMessage;
	CombatManager.showTurnMessage = showTurnMessage;

	centerOnTokenOriginal = CombatManager.centerOnToken;
	CombatManager.centerOnToken = centerOnToken;

	onNPCPostAddOriginal = CombatRecordManager.getRecordTypePostAddCallback("npc");
	CombatRecordManager.setRecordTypePostAddCallback("npc", onNPCPostAdd);

	-- for 2E, it does not call addNPCHelper
	if User.getRulesetName() == "2E" then
    	addCTANPCOriginal = CombatManagerADND.addCTANPC;
		CombatManagerADND.addCTANPC = addCTANPC;
	end

	-- left over from 5E Friend Zone code.  Is this needed?
	if CombatManagerKw then
		addUnitOriginal = CombatManagerKw.addUnit;
		CombatManagerKw.addUnit = addUnit;
	end
end

-- Special function for 2E since it uses a somewhat different combat tracker
function addCTANPC(sClass, nodeNPC, sNamedInBattle)
	local bIsCohort = FriendZone.isCohort(nodeNPC);
	local nodeEntry = addCTANPCOriginal(sClass, nodeNPC, sNamedInBattle);
	if nodeEntry and bIsCohort then
		-- Override values set by addCTANPCOriginal():
		-- 		so the nodeEntry links to the NPC on the PC Sheet
		-- 		and so it is friendly
		DB.setValue(nodeEntry, "link", "windowreference", "npc", nodeNPC.getPath());
		DB.setValue(nodeEntry, "friendfoe", "string", "friend");
	end
	return nodeEntry;
end


function showTurnMessage(nodeEntry, bActivate, bSkipBell)
	showTurnMessageOriginal(nodeEntry, bActivate, bSkipBell);

	local sClass, sRecord = DB.getValue(nodeEntry, "link", "", "");
	local bHidden = CombatManager.isCTHidden(nodeEntry);
	if not bHidden and (sClass ~= "charsheet") then -- Allow non-character sheet turns as well for the sake of cohorts.
		if bActivate and not bSkipBell and OptionsManager.isOption("RING", "on") then
			if sRecord ~= "" then
				local nodeCohort = DB.findNode(sRecord);
				if nodeCohort then
					local sOwner = nodeCohort.getOwner();
					if sOwner then
						User.ringBell(sOwner);
					end
				end
			end
		end
	end
end

function centerOnToken(nodeEntry, bOpen)
	centerOnTokenOriginal(nodeEntry, bOpen);

	if not Session.IsHost and
	FriendZone.isCohort(nodeEntry) and
	DB.isOwner(ActorManager.getCreatureNode(nodeEntry)) then
		ImageManager.centerOnToken(CombatManager.getTokenFromCT(nodeEntry), bOpen);
	end
end

function onNPCPostAdd(tCustom)
	onNPCPostAddOriginal(tCustom);
	trySetCohortLinkAndFaction(tCustom);
end

function trySetCohortLinkAndFaction(tCustom)
	local bIsCohort = FriendZone.isCohort(tCustom.nodeRecord);
	if tCustom.nodeCT and bIsCohort then
		local sClass = tCustom.sClass or LibraryData.getRecordDisplayClass(tCustom.sRecordType);
		local nodeCommander = FriendZone.getCommanderNode(tCustom.nodeRecord);
		local sFaction = ActorManager.getFaction(nodeCommander);
		DB.setValue(tCustom.nodeCT, "link", "windowreference", sClass, tCustom.nodeRecord.getPath());
		DB.setValue(tCustom.nodeCT, "friendfoe", "string", sFaction);
	end
end