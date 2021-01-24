{ stdenv, fetchFromGitHub, c-ares, cmake, libwebsockets_3_2, openssl }:

stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "1.6.8_Netdata-4";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "mosquitto";
    rev = "v.${version}";
    sha256 = "06vb9pndw3zwfnh4a8rwafdkrz00kq01vngl0zq32y74h16pp2zb";
  };

  buildInputs = [ c-ares libwebsockets_3_2 openssl ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DWITH_THREADING=YES"
    "-DWITH_WEBSOCKETS=YES"
    "-DWITH_STATIC_LIBRARIES=YES"
    "-DWITH_DOCS=NO"
  ];

  buildPhase = ''
    cd lib
    make install
  '';

  postInstall = ''
    cp $out/lib/libmosquitto_static.a $out/lib/libmosquitto.a
    cp $out/include/mosquitto.h $out/lib/mosquitto.h
  '';
}
