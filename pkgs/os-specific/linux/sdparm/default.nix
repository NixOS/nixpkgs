{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "sdparm";
  version = "1.12";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${pname}-${version}.tar.xz";
    sha256 = "sha256-xMnvr9vrZi4vlxJwfsSQkyvU0BC7ESmueplSZUburb4=";
  };

  meta = with lib; {
    homepage = "http://sg.danny.cz/sg/sdparm.html";
    description = "Utility to access SCSI device parameters";
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
