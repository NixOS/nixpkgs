{ lib, stdenv, fetchFromGitHub, nixosTests
, file, libmnl, libnftnl, libnl
, net-snmp, openssl, fetchpatch, pkg-config
, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "keepalived";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "sha256-erpYC4klkgvZ9D+4qM/qIHajsyOGKRbX7lhs6lfWFTQ=";
  };

  buildInputs = [
    file
    libmnl
    libnftnl
    libnl
    net-snmp
    openssl
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/acassen/keepalived/commit/7977fec0be89ae6fe87405b3f8da2f0b5e415e3d.patch";
      sha256 = "sha256-9TVFkgjACxln417txdVS2pCYJt5XxXWoW/afWCtKLHk=";
      name = "CVE-2021-44225.patch";
    })
  ];

  enableParallelBuilding = true;

  passthru.tests.keepalived = nixosTests.keepalived;

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  configureFlags = [
    "--enable-sha1"
    "--enable-snmp"
 ];

  meta = with lib; {
    homepage = "https://keepalived.org";
    description = "Routing software written in C";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
