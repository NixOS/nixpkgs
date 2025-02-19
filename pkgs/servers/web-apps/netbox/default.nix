{
  lib,
  nixosTests,
  callPackage,
}:
let
  generic = import ./generic.nix;
in
{
  netbox_3_7 = callPackage generic {
    version = "3.7.8";
    hash = "sha256-61pJbMWXNFnvWI0z9yWvsutdCAP4VydeceANNw0nKsk=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
    ];
    tests.netbox = nixosTests.netbox_3_7;

    maintainers = with lib.maintainers; [
      minijackson
      raitobezarius
    ];
    eol = true;
  };
}
