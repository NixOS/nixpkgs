{ stdenv, fetchurl,
IOKit ? null , ApplicationServices ? null }:

stdenv.mkDerivation rec {
  version = "6.5";
  name = "smartmontools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "1g25r6sx85b5lay5n6sbnqv05qxzj6xsafsp93hnrg1h044bps49";
  };

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [IOKit ApplicationServices];

  patches = [ ./smartmontools.patch ];

  meta = with stdenv.lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage = http://smartmontools.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.peti ];
  };
}
