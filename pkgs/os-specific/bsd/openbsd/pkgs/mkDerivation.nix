{
  lib,
  stdenv,
  stdenvNoCC,
  crossLibcStdenv,
  runCommand,
  rsync,
  source,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  install,
}:

lib.makeOverridable (
  attrs:
  let
    stdenv' =
      if attrs.noCC or false then
        stdenvNoCC
      else if attrs.noLibc or false then
        crossLibcStdenv
      else
        stdenv;
  in
  stdenv'.mkDerivation (
    rec {
      pname = "${attrs.pname or (baseNameOf attrs.path)}-openbsd";
      version = "0";
      src = runCommand "${pname}-filtered-src" { nativeBuildInputs = [ rsync ]; } ''
        for p in ${lib.concatStringsSep " " ([ attrs.path ] ++ attrs.extraPaths or [ ])}; do
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
        bsdSetupHook
        openbsdSetupHook
        makeMinimal
        install
      ];

      HOST_SH = stdenv'.shell;

      makeFlags = [
        "STRIP=-s" # flag to install, not command
        "-B"
      ];

      MACHINE_ARCH =
        {
          # amd64 not x86_64 for this on unlike NetBSD
          x86_64 = "amd64";
          aarch64 = "arm64";
          i486 = "i386";
          i586 = "i386";
          i686 = "i386";
        }
        .${stdenv'.hostPlatform.parsed.cpu.name} or stdenv'.hostPlatform.parsed.cpu.name;

      MACHINE = MACHINE_ARCH;

      MACHINE_CPU = MACHINE_ARCH;

      MACHINE_CPUARCH = MACHINE_ARCH;

      COMPONENT_PATH = attrs.path or null;

      strictDeps = true;

      meta = with lib; {
        maintainers = with maintainers; [ ericson2314 ];
        platforms = platforms.openbsd;
        license = licenses.bsd2;
      };
    }
    // lib.optionalAttrs stdenv'.hasCC {
      # TODO should CC wrapper set this?
      CPP = "${stdenv'.cc.targetPrefix}cpp";

      # Since STRIP in `makeFlags` has to be a flag, not the binary itself
      STRIPBIN = "${stdenv'.cc.bintools.targetPrefix}strip";
    }
    // lib.optionalAttrs (attrs.headersOnly or false) {
      installPhase = "includesPhase";
      dontBuild = true;
    }
    // attrs
  )
)
