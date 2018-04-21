{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, dbus, json_c, ncurses, connman }:

stdenv.mkDerivation rec {
  name = "connman-ncurses-${version}";
  version = "2015-07-21";

  src = fetchFromGitHub {
    owner = "eurogiciel-oss";
    repo = "connman-json-client";
    rev = "3c34b2ee62d2e188090d20e7ed2fd94bab9c47f2";
    sha256 = "1831r0776fv481g8kgy1dkl750pzv47835dw11sslq2k6mm6i9p1";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ dbus ncurses json_c connman ];

  NIX_CFLAGS_COMPILE = "-Wno-error";
  
  installPhase = ''
    mkdir -p "$out/bin"
    cp -va connman_ncurses "$out/bin/"
  '';

  meta = with stdenv.lib; {
    description = "Simple ncurses UI for connman";
    homepage = https://github.com/eurogiciel-oss/connman-json-client;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
