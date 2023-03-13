{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "dc3dd";
  version = "7.3.0";

  src = fetchzip {
    url = "mirror://sourceforge/dc3dd/dc3dd-${version}.zip";
    sha256 = "pYr9A9444yC0nYDOf9oDGqgzgQ5Qgtt+J4M7J35HpQg=";
  };
  preConfigure = "chmod +x ./configure";
  configureFlags = [
  "--infodir=$info/share/info"
  ] ++ (if stdenv.isDarwin then ["gl_cv_func_stpncpy=yes"] else []);
  meta = with lib; {
    description = "A patch to the GNU dd program, this version has several features intended for forensic acquisition of data.";

    homepage = "https://sourceforge.net/projects/dc3dd/";

    license = licenses.gpl3;

    platforms = platforms.all;
    maintainers = with maintainers; [ xEgoist ];
  };
}
