{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

let
  bootStages = import ../. {
    inherit lib localSystem overlays;

    crossSystem = localSystem;
    crossOverlays = [];

    # Ignore custom stdenvs when cross compiling for compatibility
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in lib.init bootStages ++ [

  # Regular native packages
  (somePrevStage: lib.last bootStages somePrevStage // {
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
  })

  # Build tool Packages
  (vanillaPackages: {
    inherit config overlays;
    stdenv =
      assert vanillaPackages.stdenv.buildPlatform == localSystem;
      assert vanillaPackages.stdenv.hostPlatform == localSystem;
      assert vanillaPackages.stdenv.targetPlatform == localSystem;
      vanillaPackages.stdenv.override { targetPlatform = crossSystem; };
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
  })

  # Prevent (some) unwanted assumptions about the number of stages
  # from creeping in.  Previously, nixpkgs contained code which
  # assumed that `pkgs.stdenv.__bootPackages == pkgs.stdenv.pkgsBuildHost`.
  #
  # We add this no-op stage here, between pkgsBuildHost and
  # pkgsHostHost, in order to deliberately break any code which
  # makes that assumption -- such code will likely fail since
  # `pkgs.stdenv.__bootPackages.hostPlatform !=
  # pkgs.stdenv.pkgsBuildHost.hostPlatform`, and will end up trying
  # to run `hostPlatform` binaries during the build.
  #
  # We previously had two additional no-op stages: one before
  # `pkgsBuildHost`, and one after `pkgsHostHost`.  However these
  # appeared to increase eval-time CPU usage by 1%, which was deemed
  # undesirable.  See https://github.com/NixOS/nixpkgs/pull/251299
  #
  (prevStage: {
    inherit config overlays;
    inherit (prevStage) stdenv;
  })

  # Run Packages
  (buildPackages: let
    adaptStdenv =
      if crossSystem.isStatic
      then buildPackages.stdenvAdapters.makeStatic
      else lib.id;
  in {
    inherit config;
    overlays = overlays ++ crossOverlays;
    stdenv = adaptStdenv (buildPackages.stdenv.override (old: rec {
      buildPlatform = localSystem;
      hostPlatform = crossSystem;
      targetPlatform = crossSystem;

      # Prior overrides are surely not valid as packages built with this run on
      # a different platform, and so are disabled.
      overrides = _: _: {};
      extraBuildInputs = [ ] # Old ones run on wrong platform
         ++ lib.optionals hostPlatform.isDarwin [ buildPackages.targetPackages.darwin.apple_sdk.frameworks.CoreFoundation ]
         ;
      allowedRequisites = null;

      hasCC = !targetPlatform.isGhcjs;

      cc = if crossSystem.useiOSPrebuilt or false
             then buildPackages.darwin.iosSdkPkgs.clang
           else if crossSystem.useAndroidPrebuilt or false
             then buildPackages."androidndkPkgs_${crossSystem.ndkVer}".clang
           else if targetPlatform.isGhcjs
             # Need to use `throw` so tryEval for splicing works, ugh.  Using
             # `null` or skipping the attribute would cause an eval failure
             # `tryEval` wouldn't catch, wrecking accessing previous stages
             # when there is a C compiler and everything should be fine.
             then throw "no C compiler provided for this platform"
           else if crossSystem.isDarwin
             then buildPackages.llvmPackages.libcxxClang
           else if crossSystem.useLLVM or false
             then buildPackages.llvmPackages.clang
           else buildPackages.gcc;

      extraNativeBuildInputs = old.extraNativeBuildInputs
        ++ lib.optionals
             (hostPlatform.isLinux && !buildPlatform.isLinux)
             [ buildPackages.patchelf ]
        ++ lib.optional
             (let f = p: !p.isx86 || builtins.elem p.libc [ "musl" "wasilibc" "relibc" ] || p.isiOS || p.isGenode;
               in f hostPlatform && !(f buildPlatform) )
             buildPackages.updateAutotoolsGnuConfigScriptsHook
        ;
    }));
  })

]
