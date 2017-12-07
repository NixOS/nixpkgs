{ stdenv, fetchFromGitHub, libnfnetlink, libnl, net_snmp, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "keepalived-${version}";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "05088vv510dlflzyg8sh8l8qfscnvxl6n6pw9ycp27zhb6r5cr5y";
  };

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
    homepage = http://keepalived.org;
    description = "Routing software written in C";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
