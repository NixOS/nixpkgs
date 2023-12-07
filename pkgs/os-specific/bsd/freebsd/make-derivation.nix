{ lib, crossLibcStdenv, stdenv, hostVersion, buildPackages, buildFreebsd, hostArchBsd, compatIfNeeded, filterSource, overrideCC, ... }:
lib.makeOverridable (attrs: let
  #crossLibcStdenv' = crossLibcStdenv // {
  #  cc = crossLibcStdenv.cc.override {
  #    cc = crossLibcStdenv.cc.cc.override {
  #      enableShared = false;
  #    };
  #  };
  #};
  stdenv' = if (attrs.isStatic or false && stdenv.targetPlatform != stdenv.hostPlatform) then crossLibcStdenv else stdenv;  # TODO stdenvNoCC?
in stdenv'.mkDerivation (rec {
  pname = "${attrs.pname or (baseNameOf attrs.path)}";
  version = hostVersion;
  src = filterSource { inherit pname; inherit (attrs) path; extraPaths = attrs.extraPaths or []; };

  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal  # TODO bmake??
    buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff #statHook
  ];
  buildInputs = compatIfNeeded;

  HOST_SH = stdenv'.shell;

  # Since STRIP below is the flag
  STRIPBIN = "${stdenv'.cc.bintools.targetPrefix}strip";

  makeFlags = [
    "STRIP=-s" # flag to install, not command
  ] ++ lib.optional (!stdenv'.hostPlatform.isFreeBSD) "MK_WERROR=no";

  # amd64 not x86_64 for this on unlike NetBSD
  MACHINE_ARCH = hostArchBsd;

  MACHINE = hostArchBsd;

  MACHINE_CPUARCH = MACHINE_ARCH;

  COMPONENT_PATH = attrs.path or null;

  strictDeps = true;

  meta = with lib; {
    maintainers = with maintainers; [ ericson2314 ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
} // lib.optionalAttrs stdenv'.hasCC {
  # TODO should CC wrapper set this?
  CPP = "${stdenv'.cc.targetPrefix}cpp";
} // lib.optionalAttrs stdenv'.isDarwin {
  MKRELRO = "no";
} // lib.optionalAttrs (stdenv'.cc.isClang or false) {
  HAVE_LLVM = lib.versions.major (lib.getVersion stdenv'.cc.cc);
} // lib.optionalAttrs (stdenv'.cc.isGNU or false) {
  HAVE_GCC = lib.versions.major (lib.getVersion stdenv'.cc.cc);
} // lib.optionalAttrs (stdenv'.isx86_32) {
  USE_SSP = "no";
} // lib.optionalAttrs (attrs.headersOnly or false) {
  installPhase = "includesPhase";
  dontBuild = true;
} // attrs))
