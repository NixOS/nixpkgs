{ stdenv, fetchFromGitHub, pkgconfig, mpd_clientlib, curl }:

stdenv.mkDerivation rec {
  name = "mpdas-${version}";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "hrkfdn";
    repo = "mpdas";
    rev = version;
    sha256 = "1i6i36jd582y3nm5plcrswqljf528hd23whp8zw06hwqnsgca5b6";
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
