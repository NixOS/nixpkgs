{ stdenv, lib, fetchFromGitHub, fetchpatch, libX11, IOKit }:

stdenv.mkDerivation rec {
  version = "0.8";
  pname = "spacenavd";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "spacenavd";
    rev = "v${version}";
    sha256 = "1zz0cm5cgvp9s5n4nzksl8rb11c7sw214bdafzra74smvqfjcjcf";
  };

  patches = [
    # Fixes Darwin: https://github.com/FreeSpacenav/spacenavd/pull/38
    (fetchpatch {
      url = "https://github.com/FreeSpacenav/spacenavd/commit/d6a25d5c3f49b9676d039775efc8bf854737c43c.patch";
      sha256 = "02pdgcvaqc20qf9hi3r73nb9ds7yk2ps9nnxaj0x9p50xjnhfg5c";
    })
  ];

  buildInputs = [ libX11 ]
    ++ lib.optional stdenv.isDarwin IOKit;

  configureFlags = [ "--disable-debug" ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    homepage = "http://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
  };
}
