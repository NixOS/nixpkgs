{ stdenv, fetchurl, openssl, libuuid, cmake, libwebsockets, c-ares, libuv }:

stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "1.4.14";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://mosquitto.org/files/source/mosquitto-${version}.tar.gz";
    sha256 = "1la2577h7hcyj7lq26vizj0sh2zmi9m7nbxjp3aalayi66kiysqm";
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
