#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright (c) 2016, 2018, Oracle and/or its affiliates. All rights reserved.
#

# All components using gobject-introspection must be built with gcc as
# gobject-introspection does not produce correct results when using Studio.
COMPILER=		gcc
BUILD_BITS =		32_and_64
include ../../../make-rules/shared-macros.mk

COMPONENT_NAME=		gdk-pixbuf
COMPONENT_VERSION=	2.36.11
COMPONENT_PROJECT_URL=	https://wiki.gnome.org/Projects/GdkPixbuf
COMPONENT_ARCHIVE_HASH= \
    sha256:ae62ab87250413156ed72ef756347b10208c00e76b222d82d9ed361ed9dde2f3
COMPONENT_BUGDB=	gnome/libraries
COMPONENT_ANITYA_ID=	9533

TPNO=			41638

SYSTEM_TEST_TARGET= $(SYSTEM_TESTS_NOT_IMPLEMENTED)
include $(WS_MAKE_RULES)/gnome-component.mk

# Requires a reconf due to patch to configure.ac.
COMPONENT_PREP_ACTION += (cd $(@D); autoreconf -fiv);

CONFIGURE_OPTIONS += --enable-gtk-doc

# Required for other components.
CONFIGURE_OPTIONS += --enable-introspection

# Build gdk-pixbuf-xlib required by xscreensaver & other software
CONFIGURE_OPTIONS += --with-x11

# Workaround for build failures due to gdk-pixbuf Makefiles not passing CFLAGS
# or LDFLAGS, especially the -m32/64 flag, to g-ir-scanner
COMPONENT_BUILD_ENV += CFLAGS="$(strip $(CFLAGS))"
COMPONENT_BUILD_ENV += LDFLAGS="$(strip $(LDFLAGS))"

# Generate and install architecture-specific configuration files that define
# the set of plugins available.
PROTOLCACHEDIR.32=	$(PROTO_DIR)/$(USRLIB.32)/gdk-pixbuf-2.0/2.10.0
PROTOLCACHEDIR.64=	$(PROTO_DIR)/$(USRLIB.64)/gdk-pixbuf-2.0/2.10.0
PROTOLCACHECONF.32=	$(PROTOLCACHEDIR.32)/loaders.cache
PROTOLCACHECONF.64=	$(PROTOLCACHEDIR.64)/loaders.cache

$(PROTOLCACHECONF.32):
	$(MKDIR) $(PROTOLCACHEDIR.32); \
	LD_LIBRARY_PATH="$(PROTO_DIR)/$(USRLIB.32):$(GLIB_LD_LIBRARY_PATH)" \
	  $(PROTO_DIR)/$(USRBIN.32)/gdk-pixbuf-query-loaders \
	  $(PROTOLCACHEDIR.32)/loaders/*.so | \
	  $(GSED) -e "s#$(PROTO_DIR)/##" > $(PROTOLCACHECONF.32)

$(PROTOLCACHECONF.64):
	$(MKDIR) $(PROTOLCACHEDIR.64); \
	LD_LIBRARY_PATH="$(PROTO_DIR)/$(USRLIB.64):$(GLIB_LD_LIBRARY_PATH)" \
	  $(PROTO_DIR)/$(USRBIN.64)/gdk-pixbuf-query-loaders \
	  $(PROTOLCACHEDIR.64)/loaders/*.so | \
	  $(GSED) -e "s#$(PROTO_DIR)/##" > $(PROTOLCACHECONF.64)

install: $(PROTOLCACHECONF.32) $(PROTOLCACHECONF.64)

# Needed for "gmake test" to work successfully.
unexport SHELLOPTS

# pixbuf-randomly-modified tests have a different random suffix each time,
# so strip that out to allow repeatable comparisons
COMPONENT_TEST_TRANSFORMS += \
	'-e "s%/pixbuf/randomly-modified/.*%/pixbuf/randomly-modified/...%"'

# Standard automake test framework results transform
COMPONENT_TEST_MASTER = $(COMPONENT_TEST_RESULTS_DIR)/results-all.master
COMPONENT_TEST_TRANSFORMS += \
        '-n ' \
        '-e "/TOTAL/p" ' \
        '-e "/SKIP/p" ' \
        '-e "/PASS/p" ' \
        '-e "/FAIL/p" ' \
        '-e "/ERROR/p" '

# Requires >= 2.69 autoconf
REQUIRED_PACKAGES += developer/documentation-tool/gtk-doc
REQUIRED_PACKAGES += image/library/libjpeg
REQUIRED_PACKAGES += image/library/libpng14
REQUIRED_PACKAGES += image/library/libtiff
REQUIRED_PACKAGES += library/desktop/gobject/gobject-introspection
REQUIRED_PACKAGES += library/glib2
REQUIRED_PACKAGES += system/library/math
REQUIRED_PACKAGES += x11/library/libx11
