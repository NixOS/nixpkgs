{ stdenv, fetchFromGitHub, libnfnetlink, libnl, net_snmp, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "keepalived-${version}";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "0lbzbw5giddr4rrhppdpsswh88x86ywxrl01vm8z5am7acixn1zr";
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
