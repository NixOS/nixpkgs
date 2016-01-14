{ stdenv, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  version = "4.4-4";
  kernelVersion = "4.4.0";
  branch = "4.4";

  src = stdenv.mkDerivation {

    name = "linux-samus-src-v${version}";

    src = fetchFromGitHub {
      owner = "raphael";
      repo = "linux-samus";
      rev = "v${version}";
      sha256 = "09v5p9azgma643b35m97c8c7bll8nrcr4gvpi5rwzryaag4w4bs8";
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r build/linux/* $out/
    '';
  };

in import ./generic.nix (args // rec {

  inherit src;

  version = kernelVersion;

  extraMeta.branch = branch;
  extraMeta.hydraPlatforms = [];

  extraConfig = ''
    LEDS_PCA9685 n
    SND_SOC n
  '';

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
