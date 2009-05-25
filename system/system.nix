{ platform ? __currentSystem
, configuration
, nixpkgs ? ../../nixpkgs
}:

rec {

  configComponents = [
    configuration
    (import ./options.nix)
  ];

  # Make a configuration object from which we can retrieve option
  # values.
  config =
    pkgs.lib.fixOptionSets
      pkgs.lib.mergeOptionSets
      pkgs configComponents;

  optionDeclarations =
    pkgs.lib.fixOptionSetsFun
      pkgs.lib.filterOptionSets
      pkgs configComponents
      config;

  pkgs = import nixpkgs {system = platform;};


  # The initial ramdisk.
  initialRamdiskStuff = import ../modules/system/boot/stage-1.nix {
    inherit pkgs config;
  };

  initialRamdisk = initialRamdiskStuff.initialRamdisk;


  # This attribute is responsible for creating boot entries for 
  # child configuration. They are only (directly) accessible
  # when the parent configuration is boot default. For example,
  # you can provide an easy way to boot the same configuration 
  # as you use, but with another kernel
  children = map (x: ((import ./system.nix)
    { inherit platform; 
      configuration = x//{boot=((x.boot)//{grubDevice = "";});};}).system) 
    config.nesting.children; 

  
  # Putting it all together.  This builds a store object containing
  # symlinks to the various parts of the built configuration (the
  # kernel, the Upstart services, the init scripts, etc.) as well as a
  # script `switch-to-configuration' that activates the configuration
  # and makes it bootable.
  system = pkgs.checker (pkgs.stdenv.mkDerivation {
    name = "system";
    builder = ./system.sh;
    switchToConfiguration = ./switch-to-configuration.sh;
    inherit (pkgs) grub upstart;
    grubDevice = config.boot.grubDevice;
    kernelParams =
      config.boot.kernelParams ++ config.boot.extraKernelParams;
    bootStage2 = config.system.build.bootStage2;
    activateConfiguration = config.system.activationScripts.script;
    grubMenuBuilder = config.system.build.grubMenuBuilder;
    etc = config.system.build.etc;
    systemPath = config.system.path;
    inherit children;
    configurationName = config.boot.configurationName;
    kernel = config.boot.kernelPackages.kernel + "/vmlinuz";
    initrd = initialRamdisk + "/initrd";
    # Most of these are needed by grub-install.
    path = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.gnugrep
      pkgs.findutils
      pkgs.diffutils
      pkgs.upstart # for initctl
    ];
    upstartInterfaceVersion = pkgs.upstart.interfaceVersion;
  }) config.environment.checkConfigurationOptions
     optionDeclarations config;

}
