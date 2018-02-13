{ stdenv, fetchzip }:

stdenv.mkDerivation rec {

  name = "supervise-${version}";
  version = "1.3.0";

  src = fetchzip {
    url = "https://github.com/catern/supervise/releases/download/v${version}/supervise-${version}.tar.gz";
    sha256 = "1y3jaqzprlkba2165nlcr250jc3mpxawd5sfjryb3db1nw66al04";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/catern/supervise;
    description = "A minimal unprivileged process supervisor making use of modern Linux features";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ catern ];
  };
}
