{ stdenv, fetchFromGitHub, nixosTests
, libnfnetlink, libnl, net-snmp, openssl
, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "keepalived";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "0zdh3g491mlc0x4g8q09vq62a7pb8n13a39jnfdgrm9k29khn0sj";
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
    homepage = "https://keepalived.org";
    description = "Routing software written in C";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
