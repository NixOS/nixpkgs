{ lib, nixosTests, callPackage, fetchpatch }:
let
  generic = import ./generic.nix;
in
{
  netbox = callPackage generic {
    version = "3.5.9";
    hash = "sha256-CJbcuCyTuihDXrObSGyJi2XF+zgWAwcJzjxtkX8pmKs=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
    ];
    tests = {
      inherit (nixosTests) netbox netbox-upgrade;
    };

    maintainers = with lib.maintainers; [ minijackson n0emis raitobezarius ];
  };

  netbox_3_6 = callPackage generic {
    version = "3.6.0";
    hash = "sha256-LLyhys9T5cNepxYeMGVSeuZ/HJNAO0/iWxA9o5Xa+2M=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
    ];
    tests = {
      netbox = nixosTests.netbox_3_6;
      inherit (nixosTests) netbox-upgrade;
    };

    maintainers = with lib.maintainers; [ raitobezarius ];
  };
}
