{ stdenv, fetchurl, xorg }:

stdenv.mkDerivation {
  pname = "libspnav";
  version = "0.2.3";
  src = fetchurl {
    url = "https://github.com/FreeSpacenav/libspnav/releases/download/libspnav-0.2.3/libspnav-0.2.3.tar.gz";
    sha256 = "14qzbzpfdb0dfscj4n0g8h8n71fcmh0ix2c7nhldlpbagyxxgr3s";
  };
  buildInputs = [ xorg.libX11 ];
}


