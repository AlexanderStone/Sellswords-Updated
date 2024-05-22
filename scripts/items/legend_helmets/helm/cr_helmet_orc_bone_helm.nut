this.cr_helmet_orc_bone_helm <- this.inherit("scripts/items/legend_helmets/legend_helmet_upgrade", {
	m = {},
	function create()
	{
		this.legend_helmet_upgrade.create();
		this.m.Type = this.Const.Items.HelmetUpgrades.Helm;
		this.m.ID = "armor.head.cr_helmet_orc_bone_helm";
		this.m.Name = "Orc Looted Bone Helm";
		this.m.Description = "An orc helm made from looted bones, patched and forged together.";
		this.m.ArmorDescription = this.m.Description;
		this.m.Variants = [
			1,
			2
		];
		this.m.Variant = this.m.Variants[this.Math.rand(0, this.m.Variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 600;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = -16;
		this.m.Vision = -1;
		this.m.IsLowerVanity = false;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ItemType = this.m.ItemType;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_lvpi_08_helmet_01";
		this.m.SpriteDamaged = "bust_lvpi_08_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_lvpi_08_helmet_01_dead";
		this.m.Icon = "helmets/inventory_helmet_cr73.png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = this.m.Icon;
		this.m.OverlayIconLarge = this.m.OverlayIcon;
	}

});

