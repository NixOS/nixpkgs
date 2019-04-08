{ stdenv, fetchFromGitHub, libnfnetlink, libnl, net_snmp, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "keepalived-${version}";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "154yxs6kwpi9yc4pa45ba3z3bfwzgmmmja5nk3d9mxq6w6s1swcy";
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
  };
}
