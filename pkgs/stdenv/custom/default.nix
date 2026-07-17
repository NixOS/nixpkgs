{
  localSystem,
  crossSystem,
  config,
  overlays,
  bootStages,
}:

assert crossSystem == localSystem;

bootStages
++ [

  # Additional stage, built using custom stdenv
  (vanillaPackages: {
    inherit config overlays;
    stdenv =
      assert vanillaPackages.stdenv.hostPlatform == localSystem;
      assert vanillaPackages.stdenv.targetPlatform == localSystem;
      let
        fn = config.replaceStdenv or null;
      in
      if fn == null then vanillaPackages.stdenv else fn { pkgs = vanillaPackages; };
  })

]
