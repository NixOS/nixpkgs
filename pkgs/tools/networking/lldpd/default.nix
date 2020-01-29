{ stdenv, lib, fetchurl, pkgconfig, removeReferencesTo
, libevent, readline, net-snmp, openssl
}:

stdenv.mkDerivation rec {
  pname = "lldpd";
  version = "1.0.4";

  src = fetchurl {
    url = "https://media.luffy.cx/files/lldpd/${pname}-${version}.tar.gz";
    sha256 = "0kvj49y6slnldi9dha81nzxvpwd7d8kq1qlibn6h1wdb5w1vq6ak";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--enable-pie"
    "--with-snmp"
    "--with-systemdsystemunitdir=\${out}/lib/systemd/system"
  ];

  nativeBuildInputs = [ pkgconfig removeReferencesTo ];
  buildInputs = [ libevent readline net-snmp openssl ];

  enableParallelBuilding = true;

  outputs = [ "out" "dev" "man" "doc" ];

  preFixup = ''
    find $out -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
  '';

  meta = with lib; {
    description = "802.1ab implementation (LLDP) to help you locate neighbors of all your equipments";
    homepage = https://vincentbernat.github.io/lldpd/;
    license = licenses.isc;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
