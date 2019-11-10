{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libdsk";
  version = "1.5.12";

  src = fetchurl {
    url = "https://www.seasip.info/Unix/LibDsk/${pname}-${version}.tar.gz";
    sha256 = "0s2k9vkrf95pf4ydc6vazb29ysrnhdpcfjnf17lpk4nmlv1j3vyv";
  };

  meta = with stdenv.lib; {
    description = "A library for accessing discs and disc image files";
    homepage = http://www.seasip.info/Unix/LibDsk/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
