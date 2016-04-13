{ stdenv, fetchgit, perl, buildLinux, ncurses, openssh, ... } @ args:

# ChromiumOS requires a 64bit build host
assert stdenv.is64bit;

import ./generic.nix (args // rec {
  version = "3.14.0";
  extraMeta.branch = "3.14";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/third_party/kernel";
    rev = "63a768b40c91c6f3518ea1f20d0cb664ed4e6a57";
    sha256 = "613527a032699be32c18d3f5d8d4c215d7718279a1c372c9f371d4e6c0b9cc34";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
  features.chromiumos = true;
} // (args.argsOverride or {}))
