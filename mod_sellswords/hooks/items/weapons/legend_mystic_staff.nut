::mods_hookExactClass("items/weapons/legend_mystic_staff", function ( o )
{
	local ws_create = o.create;
	o.create = function()
	{
		ws_create()

		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 25;
		this.m.DirectDamageMult = 0.95;
		this.m.DirectDamageAdd = 0.0;
	}
	
	local ws_onEquip = o.onEquip;
	o.onEquip = function ()
	{
		ws_onEquip()
		if (::Is_PTR_Exist)
		{
			return
		}
		
		else
		{
			this.addSkill(this.new("scripts/skills/actives/crstaff_sweep"));
		}
	}
});	