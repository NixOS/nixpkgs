{ stdenv, fetchgit, fetchFromGitHub, curl, cmake, boost, gcc, protobuf, pkgconfig, jsoncpp
, libusb1, libmicrohttpd
}:

let
  version = "1.2.1";
in

stdenv.mkDerivation rec {
  name = "trezord-${version}";

  src = fetchgit {
    url    = "https://github.com/trezor/trezord";
    rev    = "refs/tags/v${version}";
    sha256 = "1iaxmwyidjdcrc6jg0859v6v5x3qnz5b0p78pq0bypvmgyijhpm4";
  };

  common = fetchFromGitHub {
    owner = "trezor";
    repo = "trezor-common";
    rev = "b55fb61218431e9c99c9d6c1673801902fc9e92e";
    sha256 = "1zanbgz1qjs8wfwp0z91sqcvj77a9iis694k415jyd2dn4riqhdg";
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
    gcc
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

  preConfigure = ''
    ( cd src/config
      ln -s $common/protob/config.proto
      protoc -I . --cpp_out=. config.proto
    )
  '';

  LD_LIBRARY_PATH = "${stdenv.lib.makeLibraryPath [ curl ]}";
  cmakeFlags = [ "-DJSONCPP_LIBRARY='${jsoncpp}/lib/libjsoncpp.so'" ];

  installPhase = ''
    mkdir -p $out/bin
    cp trezord $out/bin
  '';
}

