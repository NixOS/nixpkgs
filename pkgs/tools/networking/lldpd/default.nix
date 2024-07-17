{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  removeReferencesTo,
  libevent,
  readline,
  net-snmp,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "lldpd";
  version = "1.0.18";

  src = fetchurl {
    url = "https://media.luffy.cx/files/lldpd/${pname}-${version}.tar.gz";
    hash = "sha256-SzIGddYIkBpKDU/v+PlruEbUkT2RSwz3W30K6ASQ8vc=";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--enable-pie"
    "--with-snmp"
    "--with-systemdsystemunitdir=\${out}/lib/systemd/system"
  ];

  nativeBuildInputs = [
    pkg-config
    removeReferencesTo
  ];
  buildInputs = [
    libevent
    readline
    net-snmp
    openssl
  ];

  enableParallelBuilding = true;

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  preFixup = ''
    find $out -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
  '';

  meta = with lib; {
    description = "802.1ab implementation (LLDP) to help you locate neighbors of all your equipments";
    homepage = "https://lldpd.github.io/";
    license = licenses.isc;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
