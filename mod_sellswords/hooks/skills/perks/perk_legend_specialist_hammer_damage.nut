::mods_hookExactClass("skills/perks/perk_legend_specialist_hammer_damage", function ( o )
{
	o.onUpdate = function( _properties )
	{
		local dc = 0;
		local actor = this.getContainer().getActor();
		if (actor.isPlayerControlled())
		{
			dc = this.getContainer().getActor().getDaysWithCompany();
		}
	
		dc = this.Math.floor(dc/7);
		dc = 0.01 * this.Math.min(5 * dc + 35, 100);		
		local item = this.getContainer().getActor().getMainhandItem();
		if (item != null)
		{
			if (item.getID() == "weapon.legend_hammer" || item.getID() == "weapon.legend_named_blacksmith_hammer")
			{
				_properties.DamageRegularMin += 6;
				_properties.DamageRegularMax += 16;
			}
			else if (item.isItemType(this.Const.Items.ItemType.OneHanded) && item.isWeaponType(this.Const.Items.WeaponType.Hammer))
			{
				_properties.DamageRegularMin += (6 * dc);
				_properties.DamageRegularMax += (16 * dc);
			}
		}
	}
});