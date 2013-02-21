args @ {
  stdenv, fetchurl, extraConfig ? "" , perl, mktemp, module_init_tools, ...
}:

let
  configWithPlatform = kernelPlatform :
    ''
      ${if kernelPlatform ? kernelExtraConfig then kernelPlatform.kernelExtraConfig else ""}
      ${extraConfig}
    '';

  rev = "91a3be5b2b";
in

import ./generic.nix (

  rec {
    version = "3.6.y-${rev}";
    testing = false;

    preConfigure = ''
      substituteInPlace scripts/depmod.sh --replace '-b "$INSTALL_MOD_PATH"' ""
    '';

    src = fetchurl {
      url = "https://api.github.com/repos/raspberrypi/linux/tarball/${rev}";
      name = "linux-raspberrypi-${version}.tar.gz";
      sha256 = "04370b1da7610622372940decdc13ddbba2a58c9da3c3bd3e7df930a399f140d";
    };

    config = configWithPlatform stdenv.platform;
    configCross = configWithPlatform stdenv.cross.platform;

    features.iwlwifi = true;
    #features.efiBootStub = true;
    #features.needsCifsUtils = true;
    #features.canDisableNetfilterConntrackHelpers = true;
    #features.netfilterRPFilter = true;
  }

  // removeAttrs args ["extraConfig"]
)
