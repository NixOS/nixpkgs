{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, docbook_xsl, libxslt
, openssl, libuuid, libwebsockets, c-ares, libuv
, systemd ? null }:

let
  withSystemd = stdenv.isLinux;

in stdenv.mkDerivation rec {
  name = "mosquitto-${version}";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner  = "eclipse";
    repo   = "mosquitto";
    rev    = "v${version}";
    sha256 = "1rf8g6fq7g1mhwsajsgvvlynasybgc51v0qg5j6ynsxfh8yi7s6r";
  };

  postPatch = ''
    for f in html manpage ; do
      substituteInPlace man/$f.xsl \
        --replace http://docbook.sourceforge.net/release/xsl/current ${docbook_xsl}/share/xml/docbook-xsl
    done

    for f in {lib,lib/cpp,src}/CMakeLists.txt ; do
      substituteInPlace $f --replace /sbin/ldconfig true
    done

    # the manpages are not generated when using cmake
    pushd man
    make
    popd
  '';

  buildInputs = [
    openssl libuuid libwebsockets c-ares libuv
  ] ++ lib.optional withSystemd systemd;

  nativeBuildInputs = [ cmake docbook_xsl libxslt ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DWITH_THREADING=ON"
    "-DWITH_WEBSOCKETS=ON"
  ] ++ lib.optional withSystemd "-DWITH_SYSTEMD=ON";

  meta = with stdenv.lib; {
    description = "An open source MQTT v3.1/3.1.1 broker";
    homepage = http://mosquitto.org/;
    license = licenses.epl10;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
