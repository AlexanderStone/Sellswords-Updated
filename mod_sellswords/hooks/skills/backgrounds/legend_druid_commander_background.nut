::mods_hookExactClass("skills/backgrounds/legend_druid_commander_background", function(o) {
	local ws_create = o.create;
	o.create = function()
	{
		ws_create();
		this.m.CustomPerkTree[3].push(this.Const.Perks.PerkDefs.laspecialize);
	}
});