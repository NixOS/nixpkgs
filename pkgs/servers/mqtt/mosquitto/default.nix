{ stdenv, fetchFromGitHub, fetchpatch, cmake, docbook_xsl, libxslt
, openssl, libuuid, libwebsockets, c-ares, libuv }:

stdenv.mkDerivation rec {
  name = "mosquitto-${version}";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner  = "eclipse";
    repo   = "mosquitto";
    rev    = "v${version}";
    sha256 = "0bknmnvssix7c1cps6mzjjnw9zxdlyfsy6ksqx4zfglcw41p8gnz";
  };

  patches = [
    # https://github.com/eclipse/mosquitto/issues/983
    (fetchpatch {
      url    = "https://github.com/eclipse/mosquitto/commit/7f1419e4de981f5cc38aa3a9684369b1de27ba46.patch";
      sha256 = "05npr0h79mbaxzjyhdw78hi9gs1cwydf2fv67bqxm81jzj2yhx2s";
      name   = "fix_threading_on_cmake.patch";
    })
  ];

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
