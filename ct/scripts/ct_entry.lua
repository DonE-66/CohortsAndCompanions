

function onInit()
	super.onInit();
	onLinkChanged(); -- call the overload.
end

function onLinkChanged()
	-- If a cohort NPC, then set up the links
	local sClass, sRecord = link.getValue();
	if FriendZone.isCohort(sRecord) then
		if sClass == "npc" then
			linkNPCFields();
		end
		name.setLine(false);
	end

	super.onLinkChanged();
end

function linkNPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);
		senses.setLink(nodeChar.createChild("senses", "string"), true);

		hp.setLink(nodeChar.createChild("hp", "number"));
		
		-- These don't exist on an NPC sheet.  Should they be added?
		
		-- hptemp.setLink(nodeChar.createChild("hp.temporary", "number"));
		-- nonlethal.setLink(nodeChar.createChild("hp.nonlethal", "number"));
		-- wounds.setLink(nodeChar.createChild("hp.wounds", "number"));

		if DataCommon.isPFRPG() then
			type.addSource(DB.getPath(nodeChar, "alignment"), true);
		else
			alignment.setLink(nodeChar.createChild("alignment", "string"));
		end
		type.addSource(DB.getPath(nodeChar, "type"));
				
		fortitudesave.setLink(nodeChar.createChild("fortitudesave", "number"), true);
		reflexsave.setLink(nodeChar.createChild("reflexsave", "number"), true);
		willsave.setLink(nodeChar.createChild("willsave", "number"), true);
		
		init.setLink(nodeChar.createChild("init", "number"), true);
	end
end