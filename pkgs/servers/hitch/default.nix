{ lib, stdenv, fetchurl, docutils, libev, openssl, pkg-config, nixosTests }:
stdenv.mkDerivation rec {
  version = "1.7.3";
  pname = "hitch";

  src = fetchurl {
    url = "https://hitch-tls.org/source/${pname}-${version}.tar.gz";
    sha256 = "sha256-Ghv0lV13W3GNwxyJoaBRdlMLDKhW+V7kKivHoj8ol4c=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ docutils libev openssl ];

  outputs = [ "out" "doc" "man" ];

  passthru.tests.hitch = nixosTests.hitch;

  meta = with lib; {
    description = "Libev-based high performance SSL/TLS proxy by Varnish Software";
    homepage = "https://hitch-tls.org/";
    license = licenses.bsd2;
    maintainers = [ maintainers.jflanglois ];
    platforms = platforms.linux;
  };
}
