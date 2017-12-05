{ stdenv, lib, fetchurl, pkgconfig, removeReferencesTo
, libevent, readline, net_snmp }:

stdenv.mkDerivation rec {
  name = "lldpd-${version}";
  version = "0.9.8";

  src = fetchurl {
    url = "https://media.luffy.cx/files/lldpd/${name}.tar.gz";
    sha256 = "0kwck17cr2f1a395a8bfmj7fz1n4i1hv429cbdbkhff33glr9r4y";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--enable-pie"
    "--with-snmp"
    "--with-systemdsystemunitdir=\${out}/lib/systemd/system"
  ];

  nativeBuildInputs = [ pkgconfig removeReferencesTo ];
  buildInputs = [ libevent readline net_snmp ];

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
