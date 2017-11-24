# this should be
#
{
  stdenv
, lib
# , buildRoot
# , srcRoot
# , ignoreConfigErrors: version, kernelConfig, runCommand
, version
, runCommand
}:
rec {
  # runCommand = name: env: buildCommand:
  /* generate a file config.nix with {
      key=val;
    }
    from a kernel .config file passed as "configfile"
    key#CONFIG_ removes "CONFIG_" prefix
    */
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

  # TODO check bash variables exist -u
  buildKernelConfig = arch: autoModules: ''
      # cd $buildRoot

      # Get a basic config file for later refinement with $generateConfig.
      # make -C ../$sourceRoot O=$PWD $kernelBaseConfig ARCH=$arch
      make -C .. O=$PWD $kernelBaseConfig ARCH=$arch

      # Create the config file.
      echo "generating kernel configuration..."
      echo "$kernelConfig" > kernel-config
      DEBUG=1 ARCH=$arch KERNEL_CONFIG=kernel-config AUTO_MODULES=$autoModules \
           PREFER_BUILTIN=$preferBuiltin SRC=../$sourceRoot perl -w $generateConfig
    '';
}


