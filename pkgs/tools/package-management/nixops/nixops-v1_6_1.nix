{ callPackage, newScope, pkgs, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.6.1";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "0lfx5fhyg3z6725ydsk0ibg5qqzp5s0x9nbdww02k8s307axiah3";
  };
  nixopsAzurePackages = with python2Packages; [
    azure-storage
    azure-mgmt-compute
    azure-mgmt-network
    azure-mgmt-resource
    azure-mgmt-storage
  ];
  # nixops is incompatible with the most recent versions of listed
  # azure-mgmt-* packages, therefore we are pinning them to
  # package-private versions, so that they don't get trampled by
  # updates.
  # see
  # https://github.com/NixOS/nixops/issues/1065
  python2Packages = pkgs.python2Packages.override {
    overrides = (self: super: let callPackage = newScope self; in {
      azure-mgmt-compute = callPackage ./azure-mgmt-compute { };
      azure-mgmt-network = callPackage ./azure-mgmt-network { };
      azure-mgmt-nspkg = callPackage ./azure-mgmt-nspkg { };
      azure-mgmt-resource = callPackage ./azure-mgmt-resource { };
      azure-mgmt-storage = callPackage ./azure-mgmt-storage { };
    });
  };
})
