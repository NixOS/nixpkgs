{ stdenv, gnustep_make, buildEnv}:

with stdenv.lib;

{
  mkDerivation =
    args @ { name, src, deps ? [], buildInputs ? [], propagatedBuildInputs ? [], ... }:
    let
      GNUSTEP_env =
	# buildEnv fails if there is only one path to symlink
        if deps == null || length deps < 1 then gnustep_make
	else buildEnv {
          name = "gnustep-env-for-${name}";
          paths = [ gnustep_make ] ++ deps;
          pathsToLink = [ "/bin" "/sbin" "/lib" "/include" "/share" ];
	};
    in
      stdenv.mkDerivation (args // {
        GNUSTEP_conf = gnustep_make.gnustepConfigTemplate;
        inherit GNUSTEP_env;
        GNUSTEP_MAKEFILES = "${GNUSTEP_env}/share/GNUstep/Makefiles";
        GNUSTEP_INSTALLATION_DOMAIN = "SYSTEM";
	buildInputs = buildInputs ++ deps ++ [ gnustep_make ];
	propagatedBuildInputs = propagatedBuildInputs ++ deps;
        preConfigure = ''
	  cp $GNUSTEP_conf $(pwd)/GNUstep-build.conf
          substituteInPlace $(pwd)/GNUstep-build.conf \
      	       --subst-var-by gnustepMakefiles $GNUSTEP_MAKEFILES \
      	       --subst-var-by systemApps "$GNUSTEP_env/lib/GNUstep/Applications" \
      	       --subst-var-by systemAdminApps "$GNUSTEP_env/lib/GNUstep/Applications" \
      	       --subst-var-by systemWebApps "$GNUSTEP_env/lib/GNUstep/WebApplications" \
      	       --subst-var-by systemTools "$GNUSTEP_env/bin" \
      	       --subst-var-by systemAdminTools "$GNUSTEP_env/sbin" \
      	       --subst-var-by systemLibrary "$GNUSTEP_env/lib" \
      	       --subst-var-by systemHeaders "$GNUSTEP_env/include" \
      	       --subst-var-by systemLibraries "$GNUSTEP_env/lib" \
      	       --subst-var-by systemDoc "$GNUSTEP_env/share/GNUstep/Documentation" \
      	       --subst-var-by systemDocMan "$GNUSTEP_env/share/man" \
      	       --subst-var-by systemDocInfo "$GNUSTEP_env/share/info"
	  export GNUSTEP_CONFIG_FILE=$(pwd)/GNUstep-build.conf
	  . $GNUSTEP_MAKEFILES/GNUstep.sh
	'';
	    buildFlags = "GNUSTEP_MAKEFILES=${GNUSTEP_env}/share/GNUstep/Makefiles";
	    configureFlags = "GNUSTEP_MAKEFILES=${GNUSTEP_env}/share/GNUstep/Makefiles";
	installFlags = "GNUSTEP_SYSTEM_APPS=\${out}/lib/GNUstep/Applications GNUSTEP_SYSTEM_ADMIN_APPS=\${out}/lib/GNUstep/Applications GNUSTEP_SYSTEM_WEB_APPS=\${out}/lib/GNUstep/WebApplications GNUSTEP_SYSTEM_TOOLS=\${out}/bin GNUSTEP_SYSTEM_ADMIN_TOOLS=\${out}/sbin GNUSTEP_SYSTEM_LIBRARY=\${out}/lib GNUSTEP_SYSTEM_HEADERS=\${out}/include GNUSTEP_SYSTEM_LIBRARIES=\${out}/lib GNUSTEP_SYSTEM_DOC=\${out}/share/GNUstep/Documentation GNUSTEP_SYSTEM_DOC_MAN=\${out}/share/man GNUSTEP_SYSTEM_DOC_INFO=\${out}/share/info GNUSTEP_SYSTEM_LIBRARIES=\${out}/lib GNUSTEP_HEADERS=\${out}/include DESTDIR_GNUSTEP_MAKEFILES=\${out}/share/GNUstep/Makefiles";
        });
}
