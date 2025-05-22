{
  lib,
  localSystem,
  crossSystem,
  config,
  overlays,
  crossOverlays ? [ ],
}:

let
  bootStages = import ../. {
    inherit lib localSystem overlays;

    crossSystem = localSystem;
    crossOverlays = [ ];

    # Ignore custom stdenvs when cross compiling for compatibility
    # Use replaceCrossStdenv instead.
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in
lib.init bootStages
++ [

  # Regular native packages
  (
    somePrevStage:
    lib.last bootStages somePrevStage
    // {
      # It's OK to change the built-time dependencies
      allowCustomOverrides = true;
    }
  )

  # Build tool Packages
  (vanillaPackages: {
    inherit config overlays;
    selfBuild = false;
    stdenv =
      assert vanillaPackages.stdenv.buildPlatform == localSystem;
      assert vanillaPackages.stdenv.hostPlatform == localSystem;
      assert vanillaPackages.stdenv.targetPlatform == localSystem;
      vanillaPackages.stdenv.override { targetPlatform = crossSystem; };
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
  })

  # Run Packages
  (
    buildPackages:
    let
      adaptStdenv = if crossSystem.isStatic then buildPackages.stdenvAdapters.makeStatic else lib.id;
      stdenvNoCC = adaptStdenv (
        buildPackages.stdenv.override (old: rec {
          buildPlatform = localSystem;
          hostPlatform = crossSystem;
          targetPlatform = crossSystem;

          # Prior overrides are surely not valid as packages built with this run on
          # a different platform, and so are disabled.
          overrides = self: super: {
            cc = # TODO: use cc when https://github.com/NixOS/nixpkgs/pull/365057 is merged
              super.ccChooser (
                if crossSystem.useLLVM or crossSystem.isDarwin then
                  "clang"
                else if crossSystem.useArocc or false then
                  "arocc"
                else if crossSystem.useZig or false then
                  "zig"
                else if crossSystem.isGhcjs then
                  null
                else
                  "gcc"
              );
          };
          extraBuildInputs = [ ]; # Old ones run on wrong platform
          allowedRequisites = null;

          cc = null;
          hasCC = false;

          extraNativeBuildInputs =
            old.extraNativeBuildInputs
            ++ lib.optionals (hostPlatform.isLinux && !buildPlatform.isLinux) [ buildPackages.patchelf ]
            ++ lib.optional (
              let
                f =
                  p:
                  !p.isx86
                  || builtins.elem p.libc [
                    "musl"
                    "wasilibc"
                    "relibc"
                  ]
                  || p.isiOS
                  || p.isGenode;
              in
              f hostPlatform && !(f buildPlatform)
            ) buildPackages.updateAutotoolsGnuConfigScriptsHook;
        })
      );
    in
    {
      inherit config;
      overlays = overlays ++ crossOverlays;
      selfBuild = false;
      inherit stdenvNoCC;
      stdenv =
        let
          inherit (stdenvNoCC) hostPlatform targetPlatform;
          baseStdenv = stdenvNoCC.override {
            # Old ones run on wrong platform
            extraBuildInputs = lib.optionals hostPlatform.isDarwin [
              buildPackages.targetPackages.apple-sdk
            ];

            hasCC = !stdenvNoCC.targetPlatform.isGhcjs;

            cc =
              if crossSystem.useiOSPrebuilt or false then
                buildPackages.darwin.iosSdkPkgs.clang
              else if crossSystem.useAndroidPrebuilt or false then
                buildPackages."androidndkPkgs_${crossSystem.androidNdkVersion}".clang
              else if
                targetPlatform.isGhcjs
              # Need to use `throw` so tryEval for splicing works, ugh.  Using
              # `null` or skipping the attribute would cause an eval failure
              # `tryEval` wouldn't catch, wrecking accessing previous stages
              # when there is a C compiler and everything should be fine.
              then
                throw "no C compiler provided for this platform"
              else if crossSystem.isDarwin then
                buildPackages.llvmPackages.libcxxClang
              # TODO: use cc when https://github.com/NixOS/nixpkgs/pull/365057 is merged
              else
                buildPackages.targetPackages.ccChooser (
                  if crossSystem.useLLVM or crossSystem.isDarwin then
                    "clang"
                  else if crossSystem.useArocc or false then
                    "arocc"
                  else if crossSystem.useZig or false then
                    "zig"
                  else if crossSystem.isGhcjs then
                    null
                  else
                    "gcc"
                );

          };
        in
        if config ? replaceCrossStdenv then
          config.replaceCrossStdenv { inherit buildPackages baseStdenv; }
        else
          baseStdenv;
    }
  )

]
