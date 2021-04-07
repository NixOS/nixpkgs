{ stdenv, lib, fetchzip, wxGTK31, coreutils, SDL2, openal, alsaLib, pkg-config
, autoreconfHook, withNetworking ? true, withALSA ? true }:

stdenv.mkDerivation rec {
  pname = "pcem";
  version = "17";

  src = fetchzip {
    url = "https://pcem-emulator.co.uk/files/PCemV${version}Linux.tar.gz";
    stripRoot = false;
    sha256 = "067pbnc15h6a4pnnym82klr1w8qwfm6p0pkx93gx06wvwqsxvbdv";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ wxGTK31 coreutils SDL2 openal ]
    ++ lib.optional withALSA alsaLib;

  configureFlags = [ "--enable-release-build" ]
    ++ lib.optional withNetworking "--enable-networking"
    ++ lib.optional withALSA "--enable-alsa";

  meta = with lib; {
    description = "Emulator for IBM PC computers and clones";
    homepage = "https://pcem-emulator.co.uk/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.terin ];
    platforms = platforms.linux ++ platforms.windows;
  };
}
