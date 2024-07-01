{ stdenv, lib, fetchFromGitHub, fetchpatch, libX11, IOKit, xorg }:

stdenv.mkDerivation rec {
  version = "1.3";
  pname = "spacenavd";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spacenavd";
    rev = "v${version}";
    sha256 = "sha256-26geQYOXjMZZ/FpPpav7zfql0davTBwB4Ir+X1oep9Q=";
  };

  patches = [
    # Changes the socket path from /run/spnav.sock to $XDG_RUNTIME_DIR/spnav.sock
    # to allow for a user service
    ./configure-socket-path.patch
    # Changes the pidfile path from /run/spnavd.pid to $XDG_RUNTIME_DIR/spnavd.pid
    # to allow for a user service
    ./configure-pidfile-path.patch
    # Changes the config file path from /etc/spnavrc to $XDG_CONFIG_HOME/spnavrc or $HOME/.config/spnavrc
    # to allow for a user service
    ./configure-cfgfile-path.patch
  ];

  buildInputs = [ libX11 xorg.libXext ]
    ++ lib.optional stdenv.isDarwin IOKit;

  configureFlags = [ "--disable-debug" ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    homepage = "https://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
  };
}
