{ stdenv, fetchzip }:

stdenv.mkDerivation rec {

  name = "supervise-${version}";
  version = "1.2.0";

  src = fetchzip {
    url = "https://github.com/catern/supervise/releases/download/v${version}/supervise-${version}.tar.gz";
    sha256 = "07v3197nf3jbx2w6jxzyk9b8p5qjj9irpr4jvv5lkfbi7s6rav3k";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/catern/supervise;
    description = "A minimal unprivileged process supervisor making use of modern Linux features";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ catern ];
  };
}
