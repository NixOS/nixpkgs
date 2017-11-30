{
  stdenv
, lib
# , config
# , buildRoot
# , srcRoot
, ignoreConfigErrors, version
# , kernelConfig
, config, configCross ?null
, kernelPatches
, runCommand
, kernel
, perl, hostPlatform
, ...
}:

# with import lib.nix;
/*

# TODO we should be able to generate standalone config and config on the go
# => we need functions with module etc
# espcially we need a bash builder
# TODO have a standalone
# etait defini dans generic.nix

There variables are exported to be used by the generate-config.pl script, see the buildPhase
debug
autoModules
preferBuiltin
ignoreConfigErrors
kernel_config

kernel-config is a file

TODO doesn t need to be a derviation ?
can 't we justr override the source or split into two derivations:
- standalone
- embedded
*/
let

  readConfig = configfile: import (runCommand "config.nix" {} ''
    echo "{" > "$out"
    while IFS='=' read key val; do
      [ "x''${key#CONFIG_}" != "x$key" ] || continue
      no_firstquote="''${val#\"}";
      echo '  "'"$key"'" = "'"''${no_firstquote%\"}"'";' >> "$out"
    done < "${configfile}"
    echo "}" >> $out
  '').outPath;

  # RENAME to 'load'
  convertKernelConfigToJson = readConfig;

  patchKconfig = ''
        # Patch kconfig to print "###" after every question so that
        # generate-config.pl from the generic builder can answer them.
        sed -e '/fflush(stdout);/i\printf("###");' -i scripts/kconfig/conf.c
  '';

  # generates functor
  #
  kernelConfigFun = baseConfig: kernelPatches:
    let
      configFromPatches =
        map ({extraConfig ? "", ...}: extraConfig) kernelPatches;
    in lib.concatStringsSep "\n" ([baseConfig] ++ configFromPatches);
in
stdenv.mkDerivation rec {
    inherit ignoreConfigErrors;
    name = "linux-config-${version}";


    # Runs generate-config
    # my $pid = open2(\*IN, \*OUT, "make -C $ENV{SRC} O=$wd config SHELL=bash ARCH=$ENV{ARCH}");
    generateConfig = ./generate-config.pl;

    # string that will be echoed to kernel-config file
    # writeFile
    # echo "$kernelConfig" > kernel-config
    kernelConfig = kernelConfigFun config kernelPatches;

    nativeBuildInputs = [ perl ];

    platformName = stdenv.platform.name;

    # sthg like "defconfig"
    kernelBaseConfig = stdenv.platform.kernelBaseConfig;

    # e.g. "bzImage"
    kernelTarget = stdenv.platform.kernelTarget;
    autoModules = stdenv.platform.kernelAutoModules;
    preferBuiltin = stdenv.platform.kernelPreferBuiltin or false;
    # kernel ARCH
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

    patchKconfig = ''
        # Patch kconfig to print "###" after every question so that
        # generate-config.pl from the generic builder can answer them.
        echo "Patching Kconfig"
        sed -e '/fflush(stdout);/i\printf("###");' -i scripts/kconfig/conf.c
  '';

    prePatch = kernel.prePatch + patchKconfig;
    # inherit (kernel) src patches preUnpack;
    inherit (kernel) src patches preUnpack;

    # TODO replace with config.nix buildPhase
    # add a cd ?
    buildPhase =  buildConfigCommands;

    # need to be in srcRoot before launching this !
    buildConfigCommands = ''
      set -x
      echo $PWD
      cd $buildRoot

      # Get a basic config file for later refinement with $generateConfig.
      # make O=$buildRoot $kernelBaseConfig ARCH=$arch
      # /$sourceRoot
      make -C .. O=$buildRoot $kernelBaseConfig ARCH=$arch

      # Create the config file.
      echo "generating kernel configuration..."
      echo "${kernelConfig}" > $buildRoot/kernel-config
      echo "Printing kernel config"
      # TODO SRC ?
      DEBUG=1 ARCH=$arch KERNEL_CONFIG=$buildRoot/kernel-config AUTO_MODULES=$autoModules \
           PREFER_BUILTIN=$preferBuiltin SRC=. BUILD_FOLDER=$buildRoot perl -w ${generateConfig}
    '';

    installPhase = "mv $buildRoot/.config $out";

    enableParallelBuilding = true;
}
