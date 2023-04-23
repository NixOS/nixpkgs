{ appleDerivation, lib, stdenv, buildPackages, python3 }:

let
  formatVersionNumeric = version:
    let
      versionParts = lib.versions.splitVersion version;
      major = lib.toInt (lib.elemAt versionParts 0);
      minor = lib.toInt (lib.elemAt versionParts 1);
      patch = if lib.length versionParts > 2 then lib.toInt (lib.elemAt versionParts 2) else 0;
    in toString (major * 10000 + minor * 100 + patch);
in

appleDerivation {
  nativeBuildInputs = [ python3 ];

  depsBuildBuild = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ buildPackages.stdenv.cc ];

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
  '' + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''

    # This looks like a bug in the makefile. It defines ENV_BUILDHOST to
    # propagate the correct value of CC, CXX, etc, but has the following double
    # expansion that results in the empty string.
    substituteInPlace makefile \
      --replace '$($(ENV_BUILDHOST))' '$(ENV_BUILDHOST)'
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ # darwin* platform properties are only defined on darwin
    # hack to use our lower macos version
    "MAC_OS_X_VERSION_MIN_REQUIRED=${formatVersionNumeric stdenv.hostPlatform.darwinMinVersion}"
    "ICU_TARGET_VERSION=-m${stdenv.hostPlatform.darwinPlatform}-version-min=${stdenv.hostPlatform.darwinMinVersion}"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS_BUILD=YES"
    "BUILD_TYPE="
    "RC_ARCHS=${stdenv.hostPlatform.darwinArch}"
    "HOSTCC=cc"
    "HOSTCXX=c++"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "HOSTISYSROOT="
    "OSX_HOST_VERSION_MIN_STRING=${stdenv.buildPlatform.darwinMinVersion}"
  ];

  doCheck = true;
  checkTarget = "check";

  postInstall = ''
    # we don't need all those in usr/local
    rm -rf $out/usr
  '';
}
