{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.16";
  extraMeta.branch = "4.13";

  # TODO: perhaps try being more concrete (ideally CVE numbers).
  extraMeta.knownVulnerabilities = [
    "ALSA: usb-audio: Fix potential out-of-bound access at parsing SU"
    "eCryptfs: use after free in ecryptfs_release_messaging()"
  ];

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0cf7prqzl1ajbgl98w0symdyn0k5wl5xaf1l5ldgy6l083yg69dh";
  };
} // (args.argsOverride or {}))
