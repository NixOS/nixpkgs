{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "2017-05-15";
  src = fetchurl {
    url = "https://static.domenkozar.com/rf5n6m8qwviaiv06sfmdwl8hndp0hxbp-nixops-1.5.1pre2159_db36cb7.tar.bz2";
    sha256 = "01b4mgql5jxin2fb2ndr1qlc8171vbb1vdljdimy8nz49dgy0gkx";
  };
})
