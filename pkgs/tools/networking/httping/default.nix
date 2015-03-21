{ stdenv, fetchurl, gettext, openssl, ncurses, fftw }:

stdenv.mkDerivation rec {
  name = "httping-${version}";

  version = "2.4";

  src = fetchurl {
    url = "http://www.vanheusden.com/httping/httping-2.4.tgz";
    sha256 = "dab59f02b08bfbbc978c005bb16d2db6fe21e1fc841fde96af3d497ddfc82084";
  };

  buildInputs = [ gettext openssl ncurses fftw ];

  configureFlags = [
    "--with-tfo"
    "--with-ncurses"
    "--with-openssl"
    "--with-fftw3"
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = {
    homepage = "http://www.vanheusden.com/httping";
    description = "ping for HTTP requests";
    maintainers = with stdenv.lib.maintainers; [ rickynils np ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
