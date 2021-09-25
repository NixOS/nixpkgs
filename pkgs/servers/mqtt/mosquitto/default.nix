{ stdenv
, lib
, fetchFromGitHub
, cmake
, docbook_xsl
, libxslt
, c-ares
, cjson
, libuuid
, libuv
, libwebsockets_3_1
, openssl
, withSystemd ? stdenv.isLinux
, systemd
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bn6vpk6gdxrnm3aw3j2g0ny6cx2arv8pmv4x8302pr6qcrz57s6";
  };

  patches = lib.optionals stdenv.isDarwin [
    (fetchpatch {
      name = "revert-cmake-shared-to-module.patch"; # See https://github.com/eclipse/mosquitto/issues/2277
      url = "https://github.com/eclipse/mosquitto/commit/e21eaeca37196439b3e89bb8fd2eb1903ef94845.patch";
      sha256 = "14syi2c1rks8sl2aw09my276w45yq1iasvzkqcrqwy4drdqrf069";
      revert = true;
    })
  ];

  postPatch = ''
    for f in html manpage ; do
      substituteInPlace man/$f.xsl \
        --replace http://docbook.sourceforge.net/release/xsl/current ${docbook_xsl}/share/xml/docbook-xsl
    done

    # the manpages are not generated when using cmake
    pushd man
    make
    popd
  '';

  nativeBuildInputs = [ cmake docbook_xsl libxslt ];

  buildInputs = [
    c-ares
    cjson
    libuuid
    libuv
    libwebsockets_3_1
    openssl
  ] ++ lib.optional withSystemd systemd;

  cmakeFlags = [
    "-DWITH_THREADING=ON"
    "-DWITH_WEBSOCKETS=ON"
  ] ++ lib.optional withSystemd "-DWITH_SYSTEMD=ON";

  meta = with lib; {
    description = "An open source MQTT v3.1/3.1.1/5.0 broker";
    homepage = "https://mosquitto.org/";
    license = licenses.epl10;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
