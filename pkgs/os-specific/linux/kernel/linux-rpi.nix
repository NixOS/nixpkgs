{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

let

  rev = "f4b20d47d7df7927967fcd524324b145cfc9e2f9";

in import ./generic.nix (args // rec {
  version = "4.1.y-${rev}";

  modDirVersion = "4.1.20-v7";

  src = fetchurl {
    url = "https://api.github.com/repos/raspberrypi/linux/tarball/${rev}";
    name = "linux-raspberrypi-${version}.tar.gz";
    sha256 = "0x17hlbi7lpmmnp24dnkync5gzj57j84j0nlrcv1lv9fahjkqsm2";
  };

  features.iwlwifi = true;

  extraMeta.hydraPlatforms = [];
})
