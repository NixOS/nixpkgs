{ stdenv, fetchFromGitHub, pkgconfig, mpd_clientlib, curl }:

stdenv.mkDerivation rec {
  name = "mpdas-${version}";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "mpdas";
    rev = version;
    sha256 = "0fcqc4w6iwbi1n3cllcgj0k61zffhqkbr8668myxap21m35x8y1r";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ mpd_clientlib curl ];

  makeFlags = [ "CONFIG=/etc" "DESTDIR=" "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Music Player Daemon AudioScrobbler";
    homepage = http://50hz.ws/mpdas/;
    license = licenses.bsd3;
    maintainers = [ maintainers.taketwo ];
    platforms = platforms.all;
  };
}
