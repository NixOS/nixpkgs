{ pkgs, ... }:


{
  machine = { config, pkgs, ... }:
    let
      configfile = builtins.storePath (builtins.toFile "config" (pkgs.lib.concatStringsSep "\n"
          (map (builtins.getAttr "configLine") config.system.requiredKernelConfig)));

      kernel = pkgs.lib.overrideDerivation (pkgs.linuxManualConfig {
        inherit (pkgs.linux) src version;
        inherit configfile;
        allowImportFromDerivation = true;
      }) (attrs: {
         configurePhase = ''
           runHook preConfigure
           mkdir ../build
           make $makeFlags "''${makeFlagsArray[@]}" mrproper
           make $makeFlags "''${makeFlagsArray[@]}" KCONFIG_ALLCONFIG=${configfile} allnoconfig
           runHook postConfigure
         '';
       });

       kernelPackages = pkgs.linuxPackagesFor kernel kernelPackages;
    in {
      boot.kernelPackages = kernelPackages;
    };

  testScript =
    ''
      startAll;
      $machine->shutdown;
    '';
}
