::Mod_Sellswords.HooksMod.hook("scripts/items/shields/named/named_wing_shield", function( q ) {
	::Mod_Sellswords.HookHelper.hookNamedItemToChangeStats(q, function() {
		this.m.MeleeDefense = 22;
		this.m.RangedDefense = 16;
		this.m.Condition = 48;
		this.m.ConditionMax = 48;
	});
});
