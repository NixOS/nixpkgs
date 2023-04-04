{ lib, nixosTests, callPackage, fetchpatch }:
let
  generic = import ./generic.nix;
in
{
  netbox_3_3 = callPackage generic {
    version = "3.3.9";
    hash = "sha256-KhnxD5pjlEIgISl4RMbhLCDwgUDfGFRi88ZcP1ndMhI=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config_3_3.patch
      ./graphql-3_2_0.patch
      # fix compatibility ith django 4.1
      (fetchpatch {
        url = "https://github.com/netbox-community/netbox/pull/10341/commits/ce6bf9e5c1bc08edc80f6ea1e55cf1318ae6e14b.patch";
        sha256 = "sha256-aCPQp6k7Zwga29euASAd+f13hIcZnIUu3RPAzNPqgxc=";
      })
    ];

    tests.netbox = nixosTests.netbox_3_3;
    maintainers = with lib.maintainers; [ n0emis raitobezarius ];
    eol = true;
  };

  netbox = callPackage generic {
    version = "3.4.7";
    hash = "sha256-pWHGyzLc0tqfehWbCMF1l96L1pewb5FXBUkw9EqPtP8=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
    ];
    tests = {
      inherit (nixosTests) netbox;
    };

    maintainers = with lib.maintainers; [ minijackson n0emis raitobezarius ];
  };
}
