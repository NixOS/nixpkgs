{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  modDirVersion = "4.9.59";
  tag = "r73";
in
import ./generic.nix (args // rec {
  version = "${modDirVersion}-ti-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "beagleboard";
    repo = "linux";
    rev = "${version}";
    sha256 = "1kzbbaqmzgvfls1v9jir2ck9vcdd774mq474vhr5x6dqjnnb5kg9";
  };

  kernelPatches = args.kernelPatches;

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta.hydraPlatforms = [];
} // (args.argsOverride or {}))
