{ stdenv, hostPlatform, fetchgit, perl, buildLinux, ncurses, ... } @ args:

# ChromiumOS requires a 64bit build host
assert stdenv.is64bit;

import ./generic.nix (args // rec {
  version = "3.18.0";
  extraMeta.branch = "3.18";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/third_party/kernel";
    rev = "3179ec7e3f07fcc3ca35817174c5fc6584030ab3";
    sha256 = "0c9ccasx9kisck23350w1xf8s7qzvgvn70xlxdbkh2b18kgm0y5f";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
  features.chromiumos = true;

  extraMeta.hydraPlatforms = [];
} // (args.argsOverride or {}))
