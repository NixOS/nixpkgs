{
  lib,
  stdenvNoCC,
  stdenv,
  fetchNetBSD,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  tsort,
  lorder,
  mandoc,
  groff,
  statHook,
  rsync,
  compatIfNeeded,
  defaultMakeFlags,
}:

lib.makeOverridable (
  attrs:
  let
    stdenv' = if attrs.noCC or false then stdenvNoCC else stdenv;
  in
  stdenv'.mkDerivation (
    {
      pname = "${attrs.pname or (baseNameOf attrs.path)}-netbsd";
      inherit (attrs) version;
      src = fetchNetBSD attrs.path attrs.version attrs.sha256;

      extraPaths = [ ];

      nativeBuildInputs = [
        bsdSetupHook
        netbsdSetupHook
        makeMinimal
        install
        tsort
        lorder
        mandoc
        groff
        statHook
        rsync
      ];
      buildInputs = compatIfNeeded;

      HOST_SH = stdenv'.shell;

      MACHINE_ARCH =
        {
          i486 = "i386";
          i586 = "i386";
          i686 = "i386";
        }
        .${stdenv'.hostPlatform.parsed.cpu.name} or stdenv'.hostPlatform.parsed.cpu.name;

      MACHINE =
        {
          x86_64 = "amd64";
          aarch64 = "evbarm64";
          i486 = "i386";
          i586 = "i386";
          i686 = "i386";
        }
        .${stdenv'.hostPlatform.parsed.cpu.name} or stdenv'.hostPlatform.parsed.cpu.name;

      COMPONENT_PATH = attrs.path;

      makeFlags = defaultMakeFlags;

      strictDeps = true;

      meta = with lib; {
        maintainers = with maintainers; [
          matthewbauer
          qyliss
        ];
        platforms = platforms.unix;
        license = licenses.bsd2;
      };
    }
    // lib.optionalAttrs stdenv'.hasCC {
      # TODO should CC wrapper set this?
      CPP = "${stdenv'.cc.targetPrefix}cpp";
    }
    // lib.optionalAttrs stdenv'.isDarwin { MKRELRO = "no"; }
    // lib.optionalAttrs (stdenv'.cc.isClang or false) {
      HAVE_LLVM = lib.versions.major (lib.getVersion stdenv'.cc.cc);
    }
    // lib.optionalAttrs (stdenv'.cc.isGNU or false) {
      HAVE_GCC = lib.versions.major (lib.getVersion stdenv'.cc.cc);
    }
    // lib.optionalAttrs (stdenv'.isx86_32) { USE_SSP = "no"; }
    // lib.optionalAttrs (attrs.headersOnly or false) {
      installPhase = "includesPhase";
      dontBuild = true;
    }
    // attrs
    // {
      # Files that use NetBSD-specific macros need to have nbtool_config.h
      # included ahead of them on non-NetBSD platforms.
      postPatch =
        lib.optionalString (!stdenv'.hostPlatform.isNetBSD) ''
          set +e
          grep -Zlr "^__RCSID
          ^__BEGIN_DECLS" $COMPONENT_PATH | xargs -0r grep -FLZ nbtool_config.h |
              xargs -0tr sed -i '0,/^#/s//#include <nbtool_config.h>\n\0/'
          set -e
        ''
        + attrs.postPatch or "";
    }
  )
)
