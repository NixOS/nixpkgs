{ stdenv,
  fetchFromGitHub,
  avahi,
  antlr3,
  autoconf,
  autoreconfHook,
  curl,
  ffmpeg,
  gawk,
  gettext,
  gnutls,
  gperf,
  json_c,
  minixml,
  openssl,
  libantlr3c,
  libconfuse,
  libevent,
  libgcrypt,
  libgpgerror,
  libplist,
  libsodium,
  libunistring,
  libuv,
  libwebsockets,
  pkg-config,
  protobufc,
  pulseaudio,
  sqlite,
  zlib,
  spotifySupport ? false, libspotify ? null
}:

stdenv.mkDerivation rec {
  pname = "forked-daapd";
  version = "27.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "ejurgensen";
    rev = version;
    sha256 = "027ysyc906g1czrpks0qla29ysma9vij88n75v09flajw2d09k6b";
  };

  nativeBuildInputs = [ antlr3
                        autoconf
                        autoreconfHook
                        ffmpeg
                        gawk
                        gettext
                        gnutls
                        gperf
                        json_c
                        libantlr3c
                        libconfuse
                        libevent
                        libgcrypt
                        libgpgerror
                        libplist
                        libsodium
                        libunistring
                        libuv
                        libwebsockets
                        minixml
                        openssl
                        pkg-config
                        protobufc
                        pulseaudio
                        sqlite
                        zlib ];

  buildInputs = [ avahi curl ] ++ stdenv.lib.optional spotifySupport libspotify;

  configureFlags = [ "--enable-chromecast"
                     "--enable-lastfm"
                     "--with-pulseaudio"
                   ] ++ stdenv.lib.optional spotifySupport "--enable-spotify";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://ejurgensen.github.io/forked-daapd";
    description = "Linux/FreeBSD DAAP (iTunes) and MPD media server with support for AirPlay devices (multiroom), Apple Remote (and compatibles), Chromecast, Spotify and internet radio.";
    license = licenses.gpl2;
    maintainers = with maintainers; [ flyfloh ];
  };
}
