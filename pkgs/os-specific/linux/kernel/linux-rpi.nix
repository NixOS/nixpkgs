{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

let

  rev = "fe4a83540ec73dfc298f16f027277355470ea9a0";

in import ./generic.nix (args // rec {
  version = "3.18.y-${rev}";

  modDirVersion = "3.18.7";

  src = fetchurl {
    url = "https://api.github.com/repos/raspberrypi/linux/tarball/${rev}";
    name = "linux-raspberrypi-${version}.tar.gz";
    sha256 = "05gq40f038hxjqd3sdb1914g2bzw533dyxy59sgdpybs8801x2vb";
  };

  features.iwlwifi = true;

  extraMeta.hydraPlatforms = [];
})
