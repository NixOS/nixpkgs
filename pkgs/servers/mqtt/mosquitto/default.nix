{ stdenv, fetchurl, openssl, libuuid, cmake, libwebsockets, c-ares, libuv }:

stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "1.4.15";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://mosquitto.org/files/source/mosquitto-${version}.tar.gz";
    sha256 = "10wsm1n4y61nz45zwk4zjhvrfd86r2cq33370m5wjkivb8j3wfvx";
  };

  buildInputs = [ openssl libuuid libwebsockets c-ares libuv ]
    ++ stdenv.lib.optional stdenv.isDarwin cmake;

  makeFlags = stdenv.lib.optionals stdenv.isLinux [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  postPatch = ''
    substituteInPlace config.mk \
      --replace "/usr/local" ""
    substituteInPlace config.mk \
      --replace "WITH_WEBSOCKETS:=no" "WITH_WEBSOCKETS:=yes"
  '';

  meta = {
    homepage = http://mosquitto.org/;
    description = "An open source MQTT v3.1/3.1.1 broker";
    platforms = stdenv.lib.platforms.unix;
    # http://www.eclipse.org/legal/epl-v10.html (free software, copyleft)
    license = stdenv.lib.licenses.epl10;
  };
}
