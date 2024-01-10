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
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
, uthash
, fetchpatch
, nixosTests
}:

let
  # Mosquitto needs external poll enabled in libwebsockets.
  libwebsockets' = (libwebsockets.override {
    withExternalPoll = true;
  }).overrideAttrs (old: {
    # Avoid bug in firefox preventing websockets being created over http/2 connections
    # https://github.com/eclipse/mosquitto/issues/1211#issuecomment-958137569
    cmakeFlags = old.cmakeFlags ++ [ "-DLWS_WITH_HTTP2=OFF" ];
  });

in
stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "2.0.18";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vs0blV2IhnlEAm0WtOartz+0vLesJfp78FNJCivRxHk=";
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
  '';

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [ cmake docbook_xsl libxslt ];

  buildInputs = [
    c-ares
    cjson
    libuuid
    libuv
    libwebsockets'
    openssl
    uthash
  ] ++ lib.optional withSystemd systemd;

  cmakeFlags = [
    (lib.cmakeBool "WITH_BUNDLED_DEPS" false)
    (lib.cmakeBool "WITH_WEBSOCKETS" true)
    (lib.cmakeBool "WITH_SYSTEMD" withSystemd)
  ];

  postFixup = ''
    sed -i "s|^prefix=.*|prefix=$lib|g" $dev/lib/pkgconfig/*.pc
  '';

  passthru.tests = {
    inherit (nixosTests) mosquitto;
  };

  meta = with lib; {
    description = "An open source MQTT v3.1/3.1.1/5.0 broker";
    homepage = "https://mosquitto.org/";
    license = licenses.epl10;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
