foreach(script in [
	"warwolf",
	"warhound",
	"wardog",
])
{
	::mods_hookExactClass("entity/tactical/" + script, function(o) {
		local onInit = o.onInit;
		o.onInit = function()
		{
			onInit();

			if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 50)
			{
				this.m.BaseProperties.MeleeSkill += 2;
				this.m.BaseProperties.Bravery += 5;

				if (this.World.getTime().Days >= 100)
				{	
					this.m.BaseProperties.MeleeDefense += 2;
					this.m.BaseProperties.Hitpoints += 5;

					if (::Is_PTR_Exist)
					{
						this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_strength_in_numbers"));	
					}		

					if (this.World.getTime().Days >= 150)
					{										
						this.m.BaseProperties.MeleeSkill += 3;			
						this.m.BaseProperties.MeleeDefense += 3;			
						this.m.BaseProperties.Bravery += 5;
						if (this.World.getTime().Days >= 200)
						{
							if (::Is_PTR_Exist)
							{
								this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_pattern_recognition"));	
							}		
							
							this.m.BaseProperties.Hitpoints += 5;													
						}		
					}
				}
			}				
		}
	});
}