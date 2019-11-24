{ stdenv, fetchFromGitHub, fetchpatch, libnfnetlink, libnl, net_snmp, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "keepalived";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "12r80rcfxrys826flaqcdlfhcr7q4ccsd62ra1svy9545vf02qmx";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-19115.patch";
      url = "https://github.com/acassen/keepalived/pull/961/commits/f28015671a4b04785859d1b4b1327b367b6a10e9.patch";
      sha256 = "1jnwk7x4qdgv7fb4jzw6sihv62n8wv04myhgwm2vxn8nfkcgd1mm";
    })
  ];

  buildInputs = [
    libnfnetlink
    libnl
    net_snmp
    openssl
  ];

  nativeBuildInputs = [ pkgconfig ];

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
