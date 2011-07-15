{stdenv, fetchurl}:

let
  name = "smartmontools-5.41";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "173eb14e3253a30230f38c7e684085bcae7fa021efff58bdf94c2702ac76fa32";
  };

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = http://smartmontools.sourceforge.net/;
    license = "GPL";
  };
}
