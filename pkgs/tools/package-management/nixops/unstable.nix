{ callPackage, fetchurl }:

# To upgrade pick the hydra job of the nixops revision that you want to upgrade
# to from: https://hydra.nixos.org/job/nixops/master/tarball
# Then copy the URL to the tarball.

callPackage ./generic.nix (rec {
  version = "1.6.1pre2728_8ed39f9";
  src = fetchurl {
    url = "https://hydra.nixos.org/build/88329589/download/2/nixops-${version}.tar.bz2";
    sha256 = "1ppnhqmsbiijm6r77h86abv3fjny5iq35yvj207s520kjwzaj7kc";
  };
  # # Marking unstable as broken, instead of using the pinned version,
  # # like stable does You might be able to use the following code (as
  # # in stable), to run unstable against the pinned packages
  # python2Packages = pkgs.python2Packages.override {
  #   overrides = (self: super: let callPackage = newScope self; in {
  #     azure-mgmt-compute = callPackage ./azure-mgmt-compute { };
  #     azure-mgmt-network = callPackage ./azure-mgmt-network { };
  #     azure-mgmt-nspkg = callPackage ./azure-mgmt-nspkg { };
  #     azure-mgmt-resource = callPackage ./azure-mgmt-resource { };
  #     azure-mgmt-storage = callPackage ./azure-mgmt-storage { };
  #   });
  # };
  # # otherwise
  # # see https://github.com/NixOS/nixpkgs/pull/52550
  # # see https://github.com/NixOS/nixops/issues/1065
  # # see https://github.com/NixOS/nixpkgs/issues/52547
  meta.broken = true;
})
