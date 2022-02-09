################################################################################
#
# mycroft-skill-ovos-settings
#
################################################################################

MYCROFT_SKILL_OVOS_SETTINGS_VERSION = c45a64ea922c29af2e848d8bcbd5aafbe4b601b5
MYCROFT_SKILL_OVOS_SETTINGS_SITE = https://github.com/OpenVoiceOS/skill-ovos-settings
MYCROFT_SKILL_OVOS_SETTINGS_SITE_METHOD = git
MYCROFT_SKILL_OVOS_SETTINGS_DIRLOCATION = home/mycroft/.local/share/mycroft/skills
MYCROFT_SKILL_OVOS_SETTINGS_DIRNAME = skill-ovos-settings.openvoiceos

define MYCROFT_SKILL_OVOS_SETTINGS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/$(MYCROFT_SKILL_OVOS_SETTINGS_DIRLOCATION)/$(MYCROFT_SKILL_OVOS_SETTINGS_DIRNAME)
	cp -dpfr $(@D)/* $(TARGET_DIR)/$(MYCROFT_SKILL_OVOS_SETTINGS_DIRLOCATION)/$(MYCROFT_SKILL_OVOS_SETTINGS_DIRNAME)
	cp -dpfr $(MYCROFT_SKILL_OVOS_SETTINGS_DL_DIR)/git/.git* \
		$(TARGET_DIR)/$(MYCROFT_SKILL_OVOS_SETTINGS_DIRLOCATION)/$(MYCROFT_SKILL_OVOS_SETTINGS_DIRNAME)
endef

$(eval $(generic-package))
