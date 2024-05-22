this.break_free_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Decal = "",
		ChanceBonus = 0,
		SkillBonus = null,
		DropNet = false, // Net item can be dropped in battle if it was thrown with Net Casting perk
		IsReinforcedNet = false,
		IsByNetSpecialist = false, // Is break free being performed by someone with Net Mastery
	},
	function setDecal( _d )
	{
		this.m.Decal = _d;
	}

	function setChanceBonus( _d )
	{
		this.m.ChanceBonus = _d;
	}

	function setSkillBonus( _d )
	{
		this.m.SkillBonus = _d;
	}

	function create()
	{
		this.m.ID = "actives.break_free";
		this.m.Name = "Break Free";
		this.m.Description = "Use everything at your disposal to free yourself from what is holding you in place. Hack, slash, cut or gnaw at it if need be!";
		this.m.Icon = "skills/active_15.png";
		this.m.IconDisabled = "skills/active_15_sw.png";
		this.m.Overlay = "active_15";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.BeforeLast;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getChance() + "%[/color] chance to succeed, based on Melee Skill. Each failed attempt will increase the chance to succeed for subsequent attempts."
			}
		];

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInNets)
		{
			tooltip.push({
				id = 5,
				type = "hint",
				icon = "ui/icons/special.png",
				text = "Net Mastery makes this signficantly easier",
			});
		}

		if (this.getContainer().getActor().getSkills().hasSkill("perk.legend_escape_artist"))
		{
			tooltip.push({
				id = 5,
				type = "hint",
				icon = "ui/icons/special.png",
				text = "Escape Artist makes this signficantly easier",
			});
		}

		return tooltip;
	}

	function getChance()
	{
		local actor = this.getContainer().getActor();
		local skill = this.m.SkillBonus == null ? actor.getCurrentProperties().getMeleeSkill() : this.m.SkillBonus;
		local toHit = this.Math.min(100, skill - 10 + this.m.ChanceBonus + (actor.getSkills().hasSkill("effects.goblin_shaman_potion") ? 100 : 0));
		if (actor.getCurrentProperties().IsSpecializedInNets || this.m.IsByNetSpecialist || actor.getSkills().hasSkill("perk.legend_escape_artist"))
		{
			toHit = this.Math.max(99, toHit);
		}
		return toHit;
	}

	function isUsable()
	{
		return this.m.IsUsable && !this.isHidden();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		local toHit = this.getChance();
		local rolled = this.Math.rand(1, 100);
		this.Tactical.EventLog.log_newline();

		if (rolled <= toHit)
		{
			if (_user.getCurrentProperties().IsSpecializedInNets)
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " effortlessly breaks free (Chance: " + toHit + ", Rolled: " + rolled + ")");
			}
			else
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " breaks free (Chance: " + toHit + ", Rolled: " + rolled + ")");
			}

			if (this.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _targetTile.Pos);
			}

			_user.getSprite("status_rooted").Visible = false;
			_user.getSprite("status_rooted_back").Visible = false;

			if (this.m.Decal != "")
			{
				local ourTile = this.getContainer().getActor().getTile();
				local candidates = [];

				if (ourTile.Properties.has("IsItemSpawned") || ourTile.IsCorpseSpawned)
				{
					for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
					{
						if (!ourTile.hasNextTile(i))
						{
						}
						else
						{
							local tile = ourTile.getNextTile(i);

							if (tile.IsEmpty && !tile.Properties.has("IsItemSpawned") && !tile.IsCorpseSpawned && tile.Level <= ourTile.Level + 1)
							{
								candidates.push(tile);
							}
						}
					}
				}
				else
				{
					candidates.push(ourTile);
				}

				if (candidates.len() != 0)
				{
					local tileToSpawnAt = candidates[this.Math.rand(0, candidates.len() - 1)];
					tileToSpawnAt.spawnDetail(this.m.Decal);
					tileToSpawnAt.Properties.add("IsItemSpawned");
				}
			}

			if (this.m.DropNet)
			{
				local net;
				if (this.m.IsReinforcedNet)
				{
					// 50% chance the reinforced net is still reusable in battle
					if (::Math.rand(1,2) == 1)
					{
						net = this.new("scripts/items/tools/reinforced_throwing_net");
						net.drop(this.getContainer().getActor().getTile());
					}
					else
					{
						this.World.Assets.getStash().add(this.new("scripts/items/tools/legend_broken_throwing_net"));
					}
				}
				else
				{
					// 25% chance the regular net is still reusable in battle
					if (::Math.rand(1,4) == 1)
					{
						net = this.new("scripts/items/tools/throwing_net");
						net.drop(this.getContainer().getActor().getTile());
					}
				}
			}

			_user.setDirty(true);
			this.getContainer().removeByID("effects.net");
			this.getContainer().removeByID("effects.rooted");
			this.getContainer().removeByID("effects.web");
			this.getContainer().removeByID("effects.kraken_ensnare");
			this.getContainer().removeByID("effects.serpent_ensnare");
			this.removeSelf();
			return true;
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " fails to break free (Chance: " + toHit + ", Rolled: " + rolled + ")");

			if (this.m.SoundOnMiss.len() != 0)
			{
				this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill, _targetTile.Pos);
			}

			this.m.ChanceBonus += 10;
			return false;
		}

		this.m.SkillBonus = null;
	}

	function onUseByAlly( _ally, _targetTile )
	{
		if (_ally.getCurrentProperties().IsSpecializedInNets)
		{
			this.m.IsByNetSpecialist = true;
		}

		this.onUse(this.getContainer().getActor(), _targetTile);
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();
		if (actor.getSprite("status_rooted").getBrush().Name == "bust_web2")
			actor.getSprite("status_rooted").Visible = false;
		if (actor.getSprite("status_rooted_back").getBrush().Name == "bust_web2_back")
			actor.getSprite("status_rooted_back").Visible = false;
		this.skill.onCombatFinished();
	}

});

