{ stdenv, fetchurl, ... } @ args:

let

  rev = "7849605f5a";

in import ./generic.nix (args // rec {
  version = "3.6.y-${rev}";

  src = fetchurl {
    url = "https://api.github.com/repos/raspberrypi/linux/tarball/${rev}";
    name = "linux-raspberrypi-${version}.tar.gz";
    sha256 = "1diwc5p6az6ipcldwmkq7hb5f15nvdgwzmypixc2vmzmc4ylarxl";
  };

  features.iwlwifi = true;

  extraMeta.hydraPlatforms = [];
})
