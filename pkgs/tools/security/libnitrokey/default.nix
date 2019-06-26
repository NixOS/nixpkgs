{ stdenv, makeWrapper, cmake, fetchFromGitHub, hidapi, libusb1, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libnitrokey-${version}";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "libnitrokey";
    rev = "v${version}";
    sha256 = "1is7ncb19n2hf42vrklnyl1xg1gz2varnkbb16cac4bjjbsn3840";
    fetchSubmodules = true;
  };

  buildInputs = [
    hidapi
    libusb1
  ];
  nativeBuildInputs = [
    cmake
    pkgconfig
    makeWrapper
  ];
  cmakeFlags = "-DCMAKE_BUILD_TYPE=Release";

  meta = with stdenv.lib; {
    description      = "Communicate with Nitrokey devices in a clean and easy manner";
    homepage         = https://github.com/Nitrokey/libnitrokey;
    repositories.git = https://github.com/Nitrokey/libnitrokey.git;
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ mog ];
  };
}
