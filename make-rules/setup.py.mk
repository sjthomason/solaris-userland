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
# Copyright (c) 2010, Oracle and/or it's affiliates.  All rights reserved.
#

$(COMPONENT_SRC)/build-$(MACH32)/.built:	BITS=32
$(COMPONENT_SRC)/build-$(MACH64)/.built:	BITS=32
$(COMPONENT_SRC)/build-$(MACH32)/.installed:	BITS=32
$(COMPONENT_SRC)/build-$(MACH64)/.installed:	BITS=64


# build the configured source
$(COMPONENT_SRC)/build-%/.built:	$(COMPONENT_SRC)/.prep
	$(RM) -r $(@D) ; $(MKDIR) $(@D)
	$(COMPONENT_PRE_BUILD_ACTION)
	(cd $(COMPONENT_SRC) ; $(ENV) $(PYTHON_ENV) \
		$(PYTHON.$(BITS)) ./setup.py build --build-temp $(@D:$(COMPONENT_SRC)/%=%))
	$(COMPONENT_POST_BUILD_ACTION)
	$(TOUCH) $@

# install the built source into a prototype area
$(COMPONENT_SRC)/build-%/.installed:	$(COMPONENT_SRC)/build-%/.built
	$(COMPONENT_PRE_INSTALL_ACTION)
	(cd $(COMPONENT_SRC) ; $(ENV) $(PYTHON_ENV) \
		$(PYTHON.$(BITS)) ./setup.py install --root $(PROTO_DIR))
	$(COMPONENT_POST_INSTALL_ACTION)
	$(TOUCH) $@
