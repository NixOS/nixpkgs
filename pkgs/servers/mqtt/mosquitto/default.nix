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
}:

stdenv.mkDerivation rec {
  pname = "mosquitto";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = pname;
    rev = "v${version}";
    sha256 = "144vw7b9ja4lci4mplbxs048x9aixd9c3s7rg6wc1k31w099rb12";
  };

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
