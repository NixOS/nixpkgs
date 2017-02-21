{ stdenv, fetchFromGitHub, libnfnetlink, libnl, net_snmp, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "keepalived-${version}";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "0vmflvr7j53dhpfawd1l2kkqw9prs2vl6r4a8rv5ilrrj3j0q989";
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
