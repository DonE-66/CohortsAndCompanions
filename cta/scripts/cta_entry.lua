
-- This is only used for 2E

function onInit()
	super.onInit();
	onLinkChanged(); -- call the overload.
end

function onLinkChanged()
	print("ENTER: 2E onLinkChanged");
	local node = getDatabaseNode();
	-- If a cohort NPC, then set up the links
	-- TODO - this is not getting the class info when dragged,
	-- but after the campaign is reloaded, then it works.
	local sClass, sRecord = DB.getValue(node,"link","","");
	print("Class is ");
	print(sClass);
	if FriendZone.isCohort(sRecord) then
		if sClass == "npc" then
			linkNPCFields(DB.findNode(sRecord));
		else
			print("Not an NPC!");
		end
		name.setLine(false);
	else
		print("Not a cohort!");
	end

	-- The super does NOT link and NPC, so it's ok to call in all cases
	super.onLinkChanged();
end


function linkNPCFields(nodeChar)
	print("ENTER: linkNPCFields");
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);
	  
		local hptotal = createControl('number_ct_crosslink_hidden','hptotal');
		local hptemp = createControl('number_ct_crosslink_hidden','hptemp');
		local wounds = createControl('number_ct_crosslink_hidden','wounds');
		
		hptotal.setLink(nodeChar.createChild("hp", "number"));
		hptemp.setLink(nodeChar.createChild("hptemporary", "number"));
		wounds.setLink(nodeChar.createChild("hpwounds", "number"));
  
	end
end

