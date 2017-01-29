{ stdenv, fetchgit, curl, cmake, boost, gcc5, protobuf, pkgconfig, jsoncpp
, libusb1, libmicrohttpd
}:

let
  version = "1.2.0";
in

stdenv.mkDerivation rec {
  name = "trezord-${version}";

  src = fetchgit {
    url    = "https://github.com/trezor/trezord";
    rev    = "refs/tags/v${version}";
    sha256 = "1606j5cfngryk4q21yiga1zvc3zpx4q8vqn6ljrvr679hpvlwni4";
  };

  meta = with stdenv.lib; {
    description = "TREZOR Bridge daemon for TREZOR bitcoin hardware wallet";
    homepage = https://mytrezor.com;
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ canndrew jb55 ];
    platforms = platforms.linux;
  };

  patches = [ ./dynamic-link.patch ];

  nativeBuildInputs = [
    cmake
    gcc5
    pkgconfig
  ];

  buildInputs = [
    curl
    boost
    protobuf
    libusb1
    libmicrohttpd
    jsoncpp
  ];

  LD_LIBRARY_PATH = "${stdenv.lib.makeLibraryPath [ curl ]}";
  cmakeFlags="-DJSONCPP_LIBRARY='${jsoncpp}/lib/libjsoncpp.so'";

  installPhase = ''
    mkdir -p $out/bin
    cp trezord $out/bin
  '';
}

