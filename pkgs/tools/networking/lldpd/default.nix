{ stdenv, lib, fetchurl, pkgconfig, removeReferencesTo
, libevent, readline, net-snmp, openssl
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "lldpd";
  version = "1.0.5";

  src = fetchurl {
    url = "https://media.luffy.cx/files/lldpd/${pname}-${version}.tar.gz";
    sha256 = "16fbqrs3l976gdslx647nds8x7sz4h5h3h4l4yxzrayvyh9b5lrd";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-27827-1.patch";
      url = "https://github.com/lldpd/lldpd/commit/a8d3c90feca548fc0656d95b5d278713db86ff61.patch";
      sha256 = "135hnq3wzga3zpmpy65jyyqyn67id9di1y3kv2qczp5jdgxfx9cy";
    })
    (fetchpatch {
      name = "CVE-2020-27827-2.patch";
      url = "https://github.com/lldpd/lldpd/commit/7d60bf30effc4c88f17f3d58ecaa72479f16d4be.patch";
      sha256 = "0b2j8sn2z7p9250iki7rx88f9cdrxv5by7cbmmmwa0h4c5cb6b61";
      excludes = [ "NEWS" ];
    })
  ];

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
    homepage = "https://vincentbernat.github.io/lldpd/";
    license = licenses.isc;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
