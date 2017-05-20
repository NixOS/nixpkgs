{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "2017-05-15";
  src = fetchurl {
    # Sadly hydra doesn't offer download links
    url = "https://static.domenkozar.com/nixops-tarball-1.5.1pre2165_b2fdc43.tar.bz2";
    sha256 = "1x8jiskxynx0rzw356sz406bi2vl0vjs7747sbacq0bp1jlnpb2n";
  };
})
