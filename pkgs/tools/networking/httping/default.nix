{ stdenv, fetchurl, gettext, ncurses }:

stdenv.mkDerivation rec {
  name = "httping-${version}";

  version = "2.4";

  src = fetchurl {
    url = "http://www.vanheusden.com/httping/${name}.tgz";
    sha256 = "1110r3gpsj9xmybdw7w4zkhj3zmn5mnv2nq0ijbvrywbn019zdfs";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ gettext ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = http://www.vanheusden.com/httping;
    description = "ping with HTTP requests";
    maintainers = with maintainers; [ nckx rickynils ];
    platforms = with platforms; linux;
  };
}
