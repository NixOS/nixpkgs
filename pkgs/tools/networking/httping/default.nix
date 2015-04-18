{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "httping-${version}";

  version = "2.3.4";

  src = fetchurl {
    url = "http://www.vanheusden.com/httping/httping-2.3.4.tgz";
    sha256 = "1hkbhdxb0phrvrddx9kcfpqlzm41xv9jvy82nfkqa7bb0v5p2qd7";
  };

  buildInputs = [ gettext ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = {
    homepage = "http://www.vanheusden.com/httping";
    description = "ping for HTTP requests";
    maintainers = with stdenv.lib.maintainers; [ rickynils ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
