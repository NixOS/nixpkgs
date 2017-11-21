# {stdenv
# , buildRoot
# , srcRoot
# }:
{
  # runCommand = name: env: buildCommand:
  readConfig = configfile: import (runCommand "config.nix" {} ''
    echo "{" > "$out"
    while IFS='=' read key val; do
      [ "x''${key#CONFIG_}" != "x$key" ] || continue
      no_firstquote="''${val#\"}";
      echo '  "'"$key"'" = "'"''${no_firstquote%\"}"'";' >> "$out"
    done < "${configfile}"
    echo "}" >> $out
  '').outPath;

  patchKconfig = ''
        # Patch kconfig to print "###" after every question so that
        # generate-config.pl from the generic builder can answer them.
        sed -e '/fflush(stdout);/i\printf("###");' -i scripts/kconfig/conf.c
  '';

  kernelConfigFun = baseConfig: kernelPatches:
    let
      configFromPatches =
        map ({extraConfig ? "", ...}: extraConfig) kernelPatches;
    in lib.concatStringsSep "\n" ([baseConfig] ++ configFromPatches);

  #
  buildKernelConfig = arch: autoModules: ''
      cd $buildRoot

      # Get a basic config file for later refinement with $generateConfig.
      make -C ../$sourceRoot O=$PWD $kernelBaseConfig ARCH=$arch

      # Create the config file.
      echo "generating kernel configuration..."
      echo "$kernelConfig" > kernel-config
      DEBUG=1 ARCH=$arch KERNEL_CONFIG=kernel-config AUTO_MODULES=$autoModules \
           PREFER_BUILTIN=$preferBuiltin SRC=../$sourceRoot perl -w $generateConfig
    '';

# TODO we should be able to generate standalone config and config on the go
# => we need functions with module etc
# espcially we need a bash builder
# TODO have a standalone
   kernelConfig = stdenv.mkDerivation {
    inherit ignoreConfigErrors;
    name = "linux-config-${version}";

    generateConfig = ./generate-config.pl;

    kernelConfig = kernelConfigFun config;

    nativeBuildInputs = [ perl ];

    platformName = stdenv.platform.name;
    kernelBaseConfig = stdenv.platform.kernelBaseConfig;
    kernelTarget = stdenv.platform.kernelTarget;
    autoModules = stdenv.platform.kernelAutoModules;
    preferBuiltin = stdenv.platform.kernelPreferBuiltin or false;
    arch = stdenv.platform.kernelArch;

    crossAttrs = let
        cp = hostPlatform.platform;
      in {
        arch = cp.kernelArch;
        platformName = cp.name;
        kernelBaseConfig = cp.kernelBaseConfig;
        kernelTarget = cp.kernelTarget;
        autoModules = cp.kernelAutoModules;

        # Just ignore all options that don't apply (We are lazy).
        ignoreConfigErrors = true;

        kernelConfig = kernelConfigFun configCross;

        inherit (kernel.crossDrv) src patches preUnpack;
      };

    prePatch = kernel.prePatch + patchKconfig;
    inherit (kernel) src patches preUnpack;

    buildPhase = ''
      cd $buildRoot

      # Get a basic config file for later refinement with $generateConfig.
      make -C ../$sourceRoot O=$PWD $kernelBaseConfig ARCH=$arch

      # Create the config file.
      echo "generating kernel configuration..."
      echo "$kernelConfig" > kernel-config
      DEBUG=1 ARCH=$arch KERNEL_CONFIG=kernel-config AUTO_MODULES=$autoModules \
           PREFER_BUILTIN=$preferBuiltin SRC=../$sourceRoot perl -w $generateConfig
    '';

    installPhase = "mv .config $out";

    enableParallelBuilding = true;
  };

}

