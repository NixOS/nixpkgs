args @ {
  stdenv, fetchgit, extraConfig ? "" , perl, mktemp, module_init_tools, ...
}:

let
  configWithPlatform = kernelPlatform :
    ''
      ${if kernelPlatform ? kernelExtraConfig then kernelPlatform.kernelExtraConfig else ""}
      ${extraConfig}
    '';
in

import ./generic.nix (

  rec {
    version = "3.6.y";
    testing = false;

    preConfigure = ''
      substituteInPlace scripts/depmod.sh --replace '-b "$INSTALL_MOD_PATH"' ""
    '';

    src = fetchgit {
      url = https://github.com/raspberrypi/linux;
      rev = "6e1f8bce970043a658d15f9350eb85152fd5fc4e";
      sha256 = "";
    };

    config = configWithPlatform stdenv.platform;
    configCross = configWithPlatform stdenv.cross.platform;

    features.iwlwifi = true;
    #features.efiBootStub = true;
    #features.needsCifsUtils = true;
    #features.canDisableNetfilterConntrackHelpers = true;
    #features.netfilterRPFilter = true;

    fetchurl = null;
  }

  // removeAttrs args ["extraConfig"]
)
