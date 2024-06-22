{
  lib,
  stdenv,
  stdenvNoCC,
  stdenvNoLibs,
  versionData,
  writeText,
  patches,
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

      HOST_SH = stdenv'.shell;

      makeFlags = [
        "STRIP=-s" # flag to install, not command
      ] ++ lib.optional (!stdenv'.hostPlatform.isFreeBSD) "MK_WERROR=no";

      # amd64 not x86_64 for this on unlike NetBSD
      MACHINE_ARCH = freebsd-lib.mkBsdArch stdenv';

      MACHINE = freebsd-lib.mkBsdArch stdenv';

      MACHINE_CPUARCH = MACHINE_ARCH;

      COMPONENT_PATH = attrs.path or null;

      strictDeps = true;

      meta =
        with lib;
        {
          maintainers = with maintainers; [
            rhelmot
            artemist
          ];
          platforms = platforms.unix;
          license = licenses.bsd2;
        }
        // attrs.meta or { };
    }
    // lib.optionalAttrs stdenv'.hasCC {
      # TODO should CC wrapper set this?
      CPP = "${stdenv'.cc.targetPrefix}cpp";

      # Since STRIP in `makeFlags` has to be a flag, not the binary itself
      STRIPBIN = "${stdenv'.cc.bintools.targetPrefix}strip";
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
        let
          isDir =
            file:
            let
              base = baseNameOf file;
              type = (builtins.readDir (dirOf file)).${base} or null;
            in
            file == /. || type == "directory";
          consolidatePatches =
            patches:
            if (lib.isDerivation patches) then
              [ patches ]
            else if (builtins.isPath patches) then
              (if (isDir patches) then (lib.filesystem.listFilesRecursive patches) else [ patches ])
            else if (builtins.isList patches) then
              (lib.flatten (builtins.map consolidatePatches patches))
            else
              throw "Bad patches - must be path or derivation or list thereof";
          consolidated = consolidatePatches patches;
          splitPatch =
            patchFile:
            let
              allLines' = lib.strings.splitString "\n" (builtins.readFile patchFile);
              allLines = builtins.filter (
                line: !((lib.strings.hasPrefix "diff --git" line) || (lib.strings.hasPrefix "index " line))
              ) allLines';
              foldFunc =
                a: b:
                if ((lib.strings.hasPrefix "--- " b) || (lib.strings.hasPrefix "diff --git " b)) then
                  (a ++ [ [ b ] ])
                else
                  ((lib.lists.init a) ++ (lib.lists.singleton ((lib.lists.last a) ++ [ b ])));
              partitionedPatches' = lib.lists.foldl foldFunc [ [ ] ] allLines;
              partitionedPatches =
                if (builtins.length partitionedPatches' > 1) then
                  (lib.lists.drop 1 partitionedPatches')
                else
                  (throw "${patchFile} does not seem to be a unified patch (diff -u). this is required for FreeBSD.");
              filterFunc =
                patchLines:
                let
                  prefixedPath = builtins.elemAt (builtins.split " |\t" (builtins.elemAt patchLines 1)) 2;
                  unfixedPath = lib.path.subpath.join (lib.lists.drop 1 (lib.path.subpath.components prefixedPath));
                in
                lib.lists.any (included: lib.path.hasPrefix (/. + ("/" + included)) (/. + ("/" + unfixedPath))) (
                  (attrs.extraPaths or [ ]) ++ [ attrs.path ]
                );
              filteredLines = builtins.filter filterFunc partitionedPatches;
              derive = patchLines: writeText "freebsd-patch" (lib.concatLines patchLines);
              derivedPatches = builtins.map derive filteredLines;
            in
            derivedPatches;
          picked = lib.lists.concatMap splitPatch consolidated;
        in
        picked ++ attrs.patches or [ ];
    }
  )
)
