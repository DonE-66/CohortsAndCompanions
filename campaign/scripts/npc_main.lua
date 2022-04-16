local updateAbilityScoresOrig;

function onInit()
    -- Create a wrapper for updateAbilityScores() in 2E campaign/scripts/npc_main.lua
    updateAbilityScoresOrig = super.updateAbilityScores;
    super.updateAbilityScores = updateAbilityScoresCohorts;
    super.onInit();
end

function updateAbilityScoresCohorts(node)
    local nodeChar = node;

    -- If the NPC is from a charsheet, it must be a cohort.  The "real"
    -- updateAbilityScores() function will pop up 4 levels to get the node if it doesn't
    -- come from a combat tracker entry or a real NPC.  So, we need to force this node
    -- down 3 levels so it will be correctly handled by the real function.
    if (node.getPath():match("^charsheet%.")) then
        nodeChar = node.getChild("abilities.strength.base");
    end

    updateAbilityScoresOrig(nodeChar);
end