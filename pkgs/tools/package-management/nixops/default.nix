{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.5.2";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "00y2arc5rffvy6xmx4p6ibpjyc61k8dkiabq7ccwwjgckz1d2dpb";
  };
})
