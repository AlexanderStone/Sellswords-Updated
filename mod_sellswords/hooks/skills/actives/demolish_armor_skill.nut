::Mod_Sellswords.HooksMod.hook("scripts/skills/actives/demolish_armor_skill", function ( q ) {

	q.onAfterUpdate = @( __original ) function( _properties)
	{
		__original(_properties);
		this.m.ActionPointCost = _properties.IsSpecializedInPolearms ? 5 : 6;
	}

});
