{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "2017-05-22";
  src = fetchurl {
    # Sadly hydra doesn't offer download links
    url = "https://static.domenkozar.com/nixops-1.5.1pre2169_8f4a67c.tar.bz2";
    sha256 = "0rma5npgkhlknmvm8z0ps54dsr07za1f32p6d6na3nis784h0slw";
  };
})
