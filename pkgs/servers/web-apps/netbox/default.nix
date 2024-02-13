{ lib, nixosTests, callPackage, }:
let
  generic = import ./generic.nix;
in
lib.fix (self: {
  netbox = self.netbox_3_7;

  netbox_3_6 = callPackage generic {
    version = "3.6.9";
    hash = "sha256-R/hcBKrylW3GnEy10DkrLVr8YJtsSCvCP9H9LhafO9I=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
    ];
    tests = {
      netbox = nixosTests.netbox_3_6;
      inherit (nixosTests) netbox-upgrade;
    };

    maintainers = with lib.maintainers; [ minijackson n0emis raitobezarius ];
    eol = true;
  };

  netbox_3_7 = callPackage generic {
    version = "3.7.1";
    hash = "sha256-hAwkrrjrV+XVIYe3C8f/342SPlllXUhiFuaAp+TLMUw=";
    extraPatches = [
      # Allow setting the STATIC_ROOT from within the configuration and setting a custom redis URL
      ./config.patch
      ./fix-doc-link.patch
    ];
    tests = {
      netbox = nixosTests.netbox_3_7;
      inherit (nixosTests) netbox-upgrade;
    };

    maintainers = with lib.maintainers; [ minijackson n0emis raitobezarius ];
  };
})
