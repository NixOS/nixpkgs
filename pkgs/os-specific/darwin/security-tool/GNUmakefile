include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = security
security_C_FILES = $(wildcard *.c)
security_CC_FILES = $(wildcard *.cpp)

security_LDFLAGS = \
	-lsecurity_cdsa_utilities -lsecurity_cdsa_utils -lsecurity_keychain -lsecurity_cssm \
	-lsecurity_cdsa_client -lsecurity_utilities -lsecurity_asn1 -lsecurity_mds \
	-lsecurity_cdsa_plugin -lsecurity_pkcs12 -lsecurity_apple_csp -lsecurity_apple_cspdl \
	-lsecurity_apple_file_dl -lsecurity_apple_x509_cl -lsecurity_apple_x509_tp \
	-lsecurity_sd_cspdl -lsecurity_filedb -lsecurityd -framework Security -framework PCSC

include $(GNUSTEP_MAKEFILES)/tool.make
