{ stdenv, fetchzip }:

stdenv.mkDerivation rec {

  name = "supervise-${version}";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/catern/supervise/releases/download/v${version}/supervise-${version}.tar.gz";
    sha256 = "0i20znchvydk8ww31ka4b0wjkaizz38racwgvqj32idwhqgar5x2";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/catern/supervise;
    description = "A minimal unprivileged process supervisor making use of modern Linux features";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ catern ];
  };
}
