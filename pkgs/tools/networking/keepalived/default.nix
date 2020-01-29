{ stdenv, fetchFromGitHub, nixosTests
, libnfnetlink, libnl, net-snmp, openssl
, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "keepalived";
  version = "2.0.20";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "0ijzw56hbac24dhrgjd0hjgf45072imyzq3mcgsirdl3xqjc6x12";
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
