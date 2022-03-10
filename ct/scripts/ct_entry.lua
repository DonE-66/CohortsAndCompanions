

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

function link4ENPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);
		senses.setLink(nodeChar.createChild("senses", "string"), true);

		-- NOTE: Not being familiar with 4E play, you might have to adjust these
		--		 slightly.   I tested and it seems to work, but some of the linked
		--		 items might be unnecessary.
		
		-- I don't think you can link main HP to the NPC sheet since it's not a numeric field.
		-- This line throws an error when you drag and drop an NPC onto the CT.
		-- hptotal.setLink(nodeChar.createChild("hp", "number"));

		-- NOTE: hptemp and wounds don't exist on the NPC sheet, but they will get 
		--		created there and linked to the cT values.   If you delete the NPC 
		--		from the CT and then re-add it later, the NPC will still have the prior values.  
		--		Might be helpful, but these 2 lines could be deleted if desired.
		hptemp.setLink(nodeChar.createChild("hptemp", "number"));
		wounds.setLink(nodeChar.createChild("wounds", "number"));
		
		alignment.setLink(nodeChar.createChild("alignment", "string"));
		type.addSource(DB.getPath(nodeChar, "type"));
		
		init.setLink(nodeChar.createChild("init", "number"), true);
		ac.setLink(nodeChar.createChild("ac", "number"), true);
		speed.setLink(nodeChar.createChild("speed", "string"), true);
	end
end

function linkPFRPGNPCFields()
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

function link2ENPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
	  name.setLink(nodeChar.createChild("name", "string"), false);
	  
	  hptotal.setLink(nodeChar.createChild("hptotal", "number"));
	  hptemp.setLink(nodeChar.createChild("hptemp", "number"));
	  wounds.setLink(nodeChar.createChild("wounds", "number"));
  
		  --- stats
	  strength.setLink(nodeChar.createChild("abilities.strength.score", "number"), true);
	  dexterity.setLink(nodeChar.createChild("abilities.dexterity.score", "number"), true);
	  constitution.setLink(nodeChar.createChild("abilities.constitution.score", "number"), true);
	  intelligence.setLink(nodeChar.createChild("abilities.intelligence.score", "number"), true);
	  wisdom.setLink(nodeChar.createChild("abilities.wisdom.score", "number"), true);
	  charisma.setLink(nodeChar.createChild("abilities.charisma.score", "number"), true);
  
		  --- saves
	  paralyzation.setLink(nodeChar.createChild("saves.paralyzation.score", "number"), true);
	  poison.setLink(nodeChar.createChild("saves.poison.score", "number"), true);
	  death.setLink(nodeChar.createChild("saves.death.score", "number"), true);
	  rod.setLink(nodeChar.createChild("saves.rod.score", "number"), true);
	  staff.setLink(nodeChar.createChild("saves.staff.score", "number"), true);
	  wand.setLink(nodeChar.createChild("saves.wand.score", "number"), true);
	  petrification.setLink(nodeChar.createChild("saves.petrification.score", "number"), true);
	  polymorph.setLink(nodeChar.createChild("saves.polymorph.score", "number"), true);
	  breath.setLink(nodeChar.createChild("saves.breath.score", "number"), true);
	  spell.setLink(nodeChar.createChild("saves.spell.score", "number"), true);
  
		  -- combat
	  init.setLink(nodeChar.createChild("init", "number"), true);
	  thaco.setLink(nodeChar.createChild("thaco", "number"), true);
	  ac.setLink(nodeChar.createChild("ac", "number"), true);
	  --bab.setLink(nodeChar.createChild("bab", "number"), true);
	  --ac_ascending.setLink(nodeChar.createChild("ac_ascending", "number"), true);
	  speed.setLink(nodeChar.createChild("speed", "number"), true);
	end
end

function linkOSE2NPCFields()
end

function linkNPCFields()
	if User.getRulesetName() == "4E" then
		print("4E");
		link4ENPCFields();
	elseif User.getRulesetName() == "2E" then
		print("2E");
		link2ENPCFields();
	elseif User.getRulesetName() == "OSE2" then
		print("OSEE");
		linkOSE2NPCFields();
	else
		print("everything else");
		linkPFRPGNPCFields();
	end
end