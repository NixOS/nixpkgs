{ lib, crossLibcStdenv, stdenv, hostVersion, buildPackages, buildFreebsd, hostArchBsd, compatIfNeeded, filterSource, ... }:
lib.makeOverridable (attrs: let
  # the use of crossLibcStdenv in the isStatic case is kind of a misnomer but I think it works
  stdenv' = if (attrs.isStatic or false) then crossLibcStdenv else stdenv;
in stdenv'.mkDerivation (rec {
  pname = "${attrs.pname or (baseNameOf attrs.path)}";
  version = hostVersion;
  src = filterSource { inherit pname; inherit (attrs) path; extraPaths = attrs.extraPaths or []; };

  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal  # TODO bmake??
    buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff #statHook
  ] ++ attrs.extraNativeBuildInputs or [];
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
    maintainers = with maintainers; [ rhelmot artemist ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  } // attrs.meta or {};
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
} // attrs // lib.optionalAttrs (stdenv'.cc.isClang or false && attrs.clangFixup or false) {
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T_DECLARED -D_SIZE_T -Dsize_t=__SIZE_TYPE__ -D_WCHAR_T"
  '' + (attrs.preBuild or "");
}))
