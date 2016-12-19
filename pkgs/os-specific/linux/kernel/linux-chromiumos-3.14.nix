{ stdenv, fetchgit, perl, buildLinux, ncurses, openssh, ... } @ args:

# ChromiumOS requires a 64bit build host
assert stdenv.is64bit;

import ./generic.nix (args // rec {
  version = "3.14.0";
  extraMeta.branch = "3.14";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/third_party/kernel";
    rev = "63a768b40c91c6f3518ea1f20d0cb664ed4e6a57";
    sha256 = "1gysrjanvnkbvgml7ipjr119bmlqfqn2zz5ca5kjkapwrfm3cb69";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
  features.chromiumos = true;
} // (args.argsOverride or {}))
