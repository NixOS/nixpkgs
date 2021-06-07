{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libdsk";
  version = "1.5.15";

  src = fetchurl {
    url = "https://www.seasip.info/Unix/LibDsk/${pname}-${version}.tar.gz";
    sha256 = "sha256-7VjVgGRy3+SE+9mdPpBKiNzv1tg2akXpkHfv2dVoODs=";
  };

  meta = with lib; {
    description = "A library for accessing discs and disc image files";
    homepage = "http://www.seasip.info/Unix/LibDsk/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
