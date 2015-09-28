include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = security_cdsa_utils

security_cdsa_utils_HEADER_FILES = $(notdir $(wildcard lib/*.h))
security_cdsa_utils_HEADER_FILES_DIR = lib

security_cdsa_utils_CC_FILES = $(wildcard lib/*.cpp)

lib/%.cpp: lib/%.m4
	m4 $< > $@

include $(GNUSTEP_MAKEFILES)/library.make
