{stdenv, fetchurl}:

let
  name = "smartmontools-5.42";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "b664d11e814e114ce3a32a4fa918c9e649c684e2897c007b2a8b92574decc374";
  };

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = http://smartmontools.sourceforge.net/;
    license = "GPL";
  };
}
