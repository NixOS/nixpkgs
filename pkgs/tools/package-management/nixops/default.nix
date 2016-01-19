{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "1.3.1";
  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "04j8s0gg1aj3wmj1bs7dwscfmlzk2xpwfw9rk4xzxwxw1y0j64nd";
  };
})
