{ stdenv, lib, fetchFromGitHub, libX11 }:

stdenv.mkDerivation rec {
  version = "0.8";
  pname = "spacenavd";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spacenavd";
    rev = "v${version}";
    sha256 = "1zz0cm5cgvp9s5n4nzksl8rb11c7sw214bdafzra74smvqfjcjcf";
  };

  buildInputs = [ libX11 ];

  patches = [
    # Changes the socket path from /run/spnav.sock to $XDG_RUNTIME_DIR/spnav.sock
    # to allow for a user service
    ./configure-socket-path.patch
  ];

  configureFlags = [ "--disable-debug"];

  meta = with lib; {
    homepage = "http://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
  };
}
