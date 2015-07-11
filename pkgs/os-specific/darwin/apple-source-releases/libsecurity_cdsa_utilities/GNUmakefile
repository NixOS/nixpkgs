include $(GNUSTEP_MAKEFILES)/common.make

LIBRARY_NAME = security_cdsa_utilities

security_cdsa_utilities_HEADER_FILES = $(notdir $(wildcard lib/*.h))
security_cdsa_utilities_HEADER_FILES_DIR = lib

security_cdsa_utilities_CC_FILES = $(wildcard lib/*.cpp) lib/Schema.cpp lib/KeySchema.cpp

lib/%.cpp: lib/%.m4
	m4 $< > $@

include $(GNUSTEP_MAKEFILES)/library.make
