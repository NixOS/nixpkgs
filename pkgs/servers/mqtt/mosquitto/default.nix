{ stdenv, fetchurl, openssl, libuuid, cmake, libwebsockets }:

stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "1.4";

  name = "${pname}-${version}";

  src = fetchurl {
    url = http://mosquitto.org/files/source/mosquitto-1.4.tar.gz;
    sha256 = "1imw5ps0cqda41b574k8hgz9gdr8yy58f76fg8gw14pdnvf3l7sr";
  };

  buildInputs = [ openssl libuuid libwebsockets ]
    ++ stdenv.lib.optional stdenv.isDarwin cmake;

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  preBuild = ''
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
