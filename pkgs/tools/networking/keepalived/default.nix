{ stdenv, fetchFromGitHub, nixosTests
, libnfnetlink, libnl, net-snmp, openssl
, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "keepalived";
  version = "2.0.19";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "05jgr0f04z69x3zf3b9z04wczl15fnh69bs6j0yw55fij1k9nj4d";
  };

  buildInputs = [
    libnfnetlink
    libnl
    net-snmp
    openssl
  ];

  passthru.tests.keepalived = nixosTests.keepalived;

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  configureFlags = [
    "--enable-sha1"
    "--enable-snmp"
 ];

  meta = with stdenv.lib; {
    homepage = https://keepalived.org;
    description = "Routing software written in C";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
