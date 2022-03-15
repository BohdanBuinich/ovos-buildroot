################################################################################
#
# mycroft-embedded-shell
#
################################################################################

MYCROFT_EMBEDDED_SHELL_VERSION = 59923ee87cb407b3c17aa283aa1001ffb8ed2d6f
MYCROFT_EMBEDDED_SHELL_SITE = $(call github,OpenVoiceOS,mycroft-embedded-shell,$(MYCROFT_EMBEDDED_SHELL_VERSION))
MYCROFT_EMBEDDED_SHELL_LICENSE = Apache License 2.0

MYCROFT_EMBEDDED_SHELL_INSTALL_STAGING = YES
MYCROFT_EMBEDDED_SHELL_DEPENDENCIES = host-pkgconf
MYCROFT_EMBEDDED_SHELL_SUPPORTS_IN_SOURCE_BUILD = NO

$(eval $(cmake-package))
