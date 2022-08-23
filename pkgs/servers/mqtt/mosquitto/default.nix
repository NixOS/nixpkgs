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
, libwebsockets
, openssl
, withSystemd ? stdenv.isLinux
, systemd
, fetchpatch
}:

let
  # Mosquitto needs external poll enabled in libwebsockets.
  libwebsockets' = libwebsockets.override {
    withExternalPoll = true;
  };
in
stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ns4dxywsy9hsmd3ybanxvzwdvzs0szc2rg43c310l4xb1sd8wm2";
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
    libwebsockets'
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
