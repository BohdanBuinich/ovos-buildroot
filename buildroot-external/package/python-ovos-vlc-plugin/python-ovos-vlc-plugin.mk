################################################################################
#
# python-ovos-vlc-plugin
#
################################################################################

PYTHON_OVOS_VLC_PLUGIN_VERSION = 6bd68e95f622ed8576da88a666812647e854fe0c
PYTHON_OVOS_VLC_PLUGIN_SITE = $(call github,OpenVoiceOS,ovos-vlc-plugin,$(PYTHON_OVOS_VLC_PLUGIN_VERSION))
PYTHON_OVOS_VLC_PLUGIN_SETUP_TYPE = setuptools
PYTHON_OVOS_VLC_PLUGIN_LICENSE_FILES = LICENSE

$(eval $(python-package))
