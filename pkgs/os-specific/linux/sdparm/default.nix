{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "sdparm-${version}";
  version = "1.11r320";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${name}.tar.xz";
    sha256 = "1crl9j1xq84sh9crwcfvnybnzif1zkrgbyz42m4iahrwima83xha";
  };

  meta = with stdenv.lib; {
    homepage = http://sg.danny.cz/sg/sdparm.html;
    description = "A utility to access SCSI device parameters";
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
