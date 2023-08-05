{ lib, nixosTests, callPackage, fetchpatch }:
let
  generic = import ./generic.nix;
in
{
  netbox_3_3 = callPackage generic {
    version = "3.3.10";
    hash = "sha256-MeOfTU5IxNDoUh7FyvwAQNRC/CE0R6p40WnlF+3RuxA=";
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
    version = "3.5.6";
    hash = "sha256-n5EJQcC5uVoL5KjGzF7bLF8c4Wke/YBJpx2V9KZz5Qo=";
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
