{ lib, stdenv, stdenvNoCC
, compatIfNeeded
, runCommand, rsync
, freebsd-lib
, source
, bsdSetupHook, freebsdSetupHook
, makeMinimal
, install, tsort, lorder, mandoc, groff
}:

lib.makeOverridable (attrs: let
  stdenv' = if attrs.noCC or false then stdenvNoCC else stdenv;
in stdenv'.mkDerivation (rec {
  pname = "${attrs.pname or (baseNameOf attrs.path)}-freebsd";
  inherit (freebsd-lib) version;
  src = runCommand "${pname}-filtered-src" {
    nativeBuildInputs = [ rsync ];
  } ''
    for p in ${lib.concatStringsSep " " ([ attrs.path ] ++ attrs.extraPaths or [])}; do
      set -x
      path="$out/$p"
      mkdir -p "$(dirname "$path")"
      src_path="${source}/$p"
      if [[ -d "$src_path" ]]; then src_path+=/; fi
      rsync --chmod="+w" -r "$src_path" "$path"
      set +x
    done
  '';

  extraPaths = [ ];

  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    makeMinimal
    install tsort lorder mandoc groff #statHook
  ];
  buildInputs = compatIfNeeded;

  HOST_SH = stdenv'.shell;

  # Since STRIP below is the flag
  STRIPBIN = "${stdenv.cc.bintools.targetPrefix}strip";

  makeFlags = [
    "STRIP=-s" # flag to install, not command
  ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";

  # amd64 not x86_64 for this on unlike NetBSD
  MACHINE_ARCH = freebsd-lib.mkBsdArch stdenv';

  MACHINE = freebsd-lib.mkBsdArch stdenv';

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
