{ stdenv, fetchFromGitHub, fetchpatch, cmake, docbook_xsl, libxslt
, openssl, libuuid, libwebsockets, c-ares, libuv }:

stdenv.mkDerivation rec {
  name = "mosquitto-${version}";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner  = "eclipse";
    repo   = "mosquitto";
    rev    = "v${version}";
    sha256 = "0pb38y6m682xqrkzhp41mj54x5ic43761xzschgnw055mzksbgk2";
  };

  postPatch = ''
    substituteInPlace man/manpage.xsl \
      --replace /usr/share/xml/docbook/stylesheet/ ${docbook_xsl}/share/xml/

    # the manpages are not generated when using cmake
    pushd man
    make
    popd
  '';

  buildInputs = [ openssl libuuid libwebsockets c-ares libuv ];

  nativeBuildInputs = [ cmake docbook_xsl libxslt ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DWITH_THREADING=ON"
  ];

  meta = with stdenv.lib; {
    description = "An open source MQTT v3.1/3.1.1 broker";
    homepage = http://mosquitto.org/;
    license = licenses.epl10;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
