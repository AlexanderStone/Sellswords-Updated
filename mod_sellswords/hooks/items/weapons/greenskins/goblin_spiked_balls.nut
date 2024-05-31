::Mod_Sellswords.HooksMod.hook("scripts/items/weapons/greenskins/goblin_spiked_balls", function ( q ) {
	
	q.create = @(__original) function()
	{
		__original()

		this.m.Value = 300;
		this.m.Ammo = 5;
		this.m.AmmoMax = 5;
		this.m.StaminaModifier = -4;
		this.m.RegularDamage = 25;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageAdd = 0.1;	

		this.m.WeaponType = this.m.WeaponType | this.Const.Items.WeaponType.Mace;
		this.setupWeaponType();
	}
});	
