{
  lib,
  localSystem,
  crossSystem,
  config,
  overlays,
  crossOverlays,
  bootStages,
}:

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
      # Stage-specific overlays can introduce a stage without changing platforms.
      # Reuse native defaults, including cycle-breaking bootstrap overrides.
      isNative = lib.systems.equals localSystem crossSystem;
      adaptStdenv = import ./adapt-stdenv.nix {
        inherit lib buildPackages;
        hostPlatform = crossSystem;
      };
      crossStdenvNoCC = adaptStdenv (
        buildPackages.stdenv.override {
          # New package stages must discard prior bootstrap package overrides
          # and HOST defaults; adapting an explicit compiler constructor does not.
          overrides = _: _: { };
          extraBuildInputs = [ ];
          allowedRequisites = null;
          cc = null;
          hasCC = false;
        }
      );
    in
    {
      inherit config;
      overlays = overlays ++ crossOverlays;
      selfBuild = false;
      stdenvNoCC = if isNative then buildPackages.stdenvNoCC else crossStdenvNoCC;
      stdenv =
        let
          inherit (crossStdenvNoCC) hostPlatform targetPlatform;
          crossStdenv = crossStdenvNoCC.override {
            # Old ones run on wrong platform
            extraBuildInputs = lib.optionals hostPlatform.isDarwin [
              buildPackages.targetPackages.apple-sdk
            ];

            hasCC = !crossStdenvNoCC.targetPlatform.isGhcjs;

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
                buildPackages.llvmPackages.systemLibcxxClang
              else if crossSystem.useLLVM or false then
                buildPackages.llvmPackages.clang
              else if crossSystem.useZig or false then
                buildPackages.zig.cc
              else if crossSystem.useArocc or false then
                buildPackages.arocc
              else if crossSystem.useGccNG or false then
                buildPackages.gccNGPackages.gcc
              else
                buildPackages.gcc;

          };
          baseStdenv = if isNative then buildPackages.stdenv else crossStdenv;
        in
        if config ? replaceCrossStdenv then
          config.replaceCrossStdenv { inherit buildPackages baseStdenv; }
        else
          baseStdenv;
    }
  )

]
