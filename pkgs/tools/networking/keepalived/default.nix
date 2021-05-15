{ lib, stdenv, fetchFromGitHub, nixosTests
, libnfnetlink, libnl, net-snmp, openssl
, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "keepalived";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "sha256-qugEEbOQ4bemzelIOaNFvo3piMZpKUZGjR+4XF8aLHw=";
  };

  buildInputs = [
    libnfnetlink
    libnl
    net-snmp
    openssl
  ];

  passthru.tests.keepalived = nixosTests.keepalived;

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  configureFlags = [
    "--enable-sha1"
    "--enable-snmp"
 ];

  meta = with lib; {
    homepage = "https://keepalived.org";
    description = "Routing software written in C";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
