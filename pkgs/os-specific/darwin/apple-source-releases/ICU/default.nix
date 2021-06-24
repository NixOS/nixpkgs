{ appleDerivation, python3 }:

appleDerivation {
  nativeBuildInputs = [ python3 ];

  postPatch = ''
    substituteInPlace makefile \
      --replace "/usr/bin/" "" \
      --replace "xcrun --sdk macosx --find" "echo -n" \
      --replace "xcrun --sdk macosx.internal --show-sdk-path" "echo -n /dev/null" \
      --replace "-install_name " "-install_name $out"

    substituteInPlace icuSources/config/mh-darwin \
      --replace "-install_name " "-install_name $out/"

    # drop using impure /var/db/timezone/icutz
    substituteInPlace makefile \
      --replace '-DU_TIMEZONE_FILES_DIR=\"\\\"$(TZDATA_LOOKUP_DIR)\\\"\" -DU_TIMEZONE_PACKAGE=\"\\\"$(TZDATA_PACKAGE)\\\"\"' ""

    # FIXME: This will cause `ld: warning: OS version (12.0) too small, changing to 13.0.0`, APPLE should fix it.
    substituteInPlace makefile \
      --replace "ZIPPERING_LDFLAGS=-Wl,-iosmac_version_min,12.0" "ZIPPERING_LDFLAGS="

    # skip test for missing encodingSamples data
    substituteInPlace icuSources/test/cintltst/ucsdetst.c \
      --replace "&TestMailFilterCSS" "NULL"

    patchShebangs icuSources
  '';

  # APPLE is using makefile to save its default configuration and call ./configure, so we hack makeFlags
  # instead of configuring ourself, trying to stay abreast of APPLE.
  dontConfigure = true;
  makeFlags = [
    "DSTROOT=$(out)"

    # remove /usr prefix on include and lib
    "PRIVATE_HDR_PREFIX="
    "libdir=/lib/"

    "DATA_INSTALL_DIR=/share/icu/"
    "DATA_LOOKUP_DIR=$(DSTROOT)$(DATA_INSTALL_DIR)"

    # hack to use our lower macos version
    "MAC_OS_X_VERSION_MIN_REQUIRED=__MAC_OS_X_VERSION_MIN_REQUIRED"
    "OSX_HOST_VERSION_MIN_STRING=$(MACOSX_DEPLOYMENT_TARGET)"
  ];

  doCheck = true;
  checkTarget = "check";

  postInstall = ''
    # we don't need all those in usr/local
    rm -rf $out/usr
  '';
}
