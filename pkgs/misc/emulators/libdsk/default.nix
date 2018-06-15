{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libdsk-${version}";
  version = "1.5.8";

  src = fetchurl {
    url = "http://www.seasip.info/Unix/LibDsk/${name}.tar.gz";
    sha256 = "1fdypk6gjkb4i2ghnbn3va50y69pdym51jx3iz9jns4636z4sfqd";
  };

  meta = with stdenv.lib; {
    description = "A library for accessing discs and disc image files";
    homepage = http://www.seasip.info/Unix/LibDsk/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
