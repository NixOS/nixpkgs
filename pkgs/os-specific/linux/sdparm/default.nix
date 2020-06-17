{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "sdparm";
  version = "1.11";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${pname}-${version}.tar.xz";
    sha256 = "1nqjc4w2w47zavcbf5xmm53x1zbwgljaw1lpajcdi537cgy32fa8";
  };

  meta = with stdenv.lib; {
    homepage = "http://sg.danny.cz/sg/sdparm.html";
    description = "A utility to access SCSI device parameters";
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
