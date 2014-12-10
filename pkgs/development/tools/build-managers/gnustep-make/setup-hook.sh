# this path is used by some packages to install additional makefiles
export DESTDIR_GNUSTEP_MAKEFILES=$out/share/GNUstep/Makefiles

installFlagsArray=( \
  "GNUSTEP_INSTALLATION_DOMAIN=SYSTEM" \
  "GNUSTEP_SYSTEM_APPS=$out/lib/GNUstep/Applications" \
  "GNUSTEP_SYSTEM_ADMIN_APPS=$out/lib/GNUstep/Applications" \
  "GNUSTEP_SYSTEM_WEB_APPS=$out/lib/GNUstep/WebApplications" \
  "GNUSTEP_SYSTEM_TOOLS=$out/bin" \
  "GNUSTEP_SYSTEM_ADMIN_TOOLS=$out/sbin" \
  "GNUSTEP_SYSTEM_LIBRARY=$out/lib" \
  "GNUSTEP_SYSTEM_HEADERS=$out/include" \
  "GNUSTEP_SYSTEM_LIBRARIES=$out/lib" \
  "GNUSTEP_SYSTEM_DOC=$out/share/GNUstep/Documentation" \
  "GNUSTEP_SYSTEM_DOC_MAN=$out/share/man" \
  "GNUSTEP_SYSTEM_DOC_INFO=$out/share/info" \
  "GNUSTEP_SYSTEM_LIBRARIES=$out/lib" \
  "GNUSTEP_HEADERS=$out/include" \
)

addGSMakefilesPath () {
    local filename

    for filename in $1/share/GNUstep/Makefiles/Additional/*.make ; do
	export NIX_GNUSTEP_MAKEFILES_ADDITIONAL="$NIX_GNUSTEP_MAKEFILES_ADDITIONAL $filename"
    done
}

envHooks=(${envHooks[@]} addGSMakefilesPath)
