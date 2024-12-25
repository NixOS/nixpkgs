{
  lib,
  stdenv,
  stdenvNoCC,
  stdenvNoLibs,
  overrideCC,
  buildPackages,
  stdenvNoLibcxx ? overrideCC stdenv buildPackages.llvmPackages.clangNoLibcxx,
  versionData,
  patchesRoot,
  compatIfNeeded,
  freebsd-lib,
  filterSource,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  install,
  tsort,
  lorder,
  mandoc,
  groff,
}:

lib.makeOverridable (
  attrs:
  let
    stdenv' =
      if attrs.noCC or false then
        stdenvNoCC
      else if attrs.noLibc or false then
        stdenvNoLibs
      else if attrs.noLibcxx or false then
        stdenvNoLibcxx
      else
        stdenv;
  in
  stdenv'.mkDerivation (
    rec {
      inherit (freebsd-lib) version;
      pname = "${attrs.pname or (baseNameOf attrs.path)}";
      src = filterSource {
        inherit pname;
        inherit (attrs) path;
        extraPaths = attrs.extraPaths or [ ];
      };

      nativeBuildInputs = [
        bsdSetupHook
        freebsdSetupHook
        makeMinimal
        install
        tsort
        lorder
        mandoc
        groff
      ] ++ attrs.extraNativeBuildInputs or [ ];
      buildInputs = compatIfNeeded;

      makeFlags =
        [
          "STRIP=-s" # flag to install, not command
        ]
        ++ lib.optional (!stdenv'.hostPlatform.isFreeBSD) "MK_WERROR=no"
        ++ lib.optional stdenv.hostPlatform.isStatic "SHLIB_NAME=";

      env =
        {
          HOST_SH = stdenv'.shell;

          # amd64 not x86_64 for this on unlike NetBSD
          MACHINE_ARCH = freebsd-lib.mkBsdArch stdenv';

          MACHINE = freebsd-lib.mkBsdMachine stdenv';

          MACHINE_CPUARCH = freebsd-lib.mkBsdCpuArch stdenv';

          COMPONENT_PATH = attrs.path or null;

          # don't set filesystem flags that require root
          NO_FSCHG = "yes";
        }
        // lib.optionalAttrs stdenv'.hasCC {
          # TODO should CC wrapper set this?
          CPP = "${stdenv'.cc.targetPrefix}cpp";

          # Since STRIP in `makeFlags` has to be a flag, not the binary itself
          STRIPBIN = "${stdenv'.cc.bintools.targetPrefix}strip";
        }
        // lib.optionalAttrs (!stdenv.hostPlatform.isFreeBSD) { BOOTSTRAPPING = true; }
        // lib.optionalAttrs stdenv'.hostPlatform.isDarwin { MKRELRO = "no"; }
        // lib.optionalAttrs (stdenv'.cc.isClang or false) {
          HAVE_LLVM = lib.versions.major (lib.getVersion stdenv'.cc.cc);
        }
        // lib.optionalAttrs (stdenv'.cc.isGNU or false) {
          HAVE_GCC = lib.versions.major (lib.getVersion stdenv'.cc.cc);
        }
        // lib.optionalAttrs (stdenv'.hostPlatform.isx86_32) { USE_SSP = "no"; }
        // (attrs.env or { });

      strictDeps = true;

      meta = {
        maintainers = with lib.maintainers; [
          rhelmot
          artemist
        ];
        platforms = lib.platforms.unix;
        license = lib.licenses.bsd2;
      } // attrs.meta or { };
    }
    // lib.optionalAttrs (attrs.headersOnly or false) {
      installPhase = "includesPhase";
      dontBuild = true;
    }
    // (builtins.removeAttrs attrs [ "env" ])
    // lib.optionalAttrs (stdenv'.hasCC && stdenv'.cc.isClang or false && attrs.clangFixup or true) {
      preBuild =
        ''
          export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T_DECLARED -D_SIZE_T -Dsize_t=__SIZE_TYPE__ -D_WCHAR_T"
        ''
        + lib.optionalString (versionData.major == 13) ''
          export NIX_LDFLAGS="$NIX_LDFLAGS --undefined-version"
        ''
        + (attrs.preBuild or "");
    }
    // {
      patches =
        (lib.optionals (attrs.autoPickPatches or true) (
          freebsd-lib.filterPatches patchesRoot (
            attrs.extraPaths or [ ] ++ (lib.optional (attrs ? path) attrs.path)
          )
        ))
        ++ attrs.patches or [ ];
    }
    //
      lib.optionalAttrs
        (!stdenv.hostPlatform.isStatic && !attrs.alwaysKeepStatic or false && stdenv.hostPlatform.isFreeBSD)
        {
          postInstall =
            (attrs.postInstall or "")
            + ''
              rm -f $out/lib/*.a
            '';
        }
    //
      lib.optionalAttrs
        ((stdenv.hostPlatform.isStatic || !stdenv.hostPlatform.isFreeBSD) && attrs ? outputs)
        {
          outputs = lib.lists.remove "debug" attrs.outputs;
        }
  )
)
