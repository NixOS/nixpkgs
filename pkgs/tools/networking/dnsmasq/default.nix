{ stdenv, fetchurl, pkgconfig
, withConntrack ? false, libnetfilter_conntrack ? null, libnfnetlink ? null
, withDbus ? false, dbus ? null
, withDnssec ? true, nettle ? null
}:

assert withDnssec -> true;
assert withConntrack -> libnetfilter_conntrack != null && libnfnetlink != null;
assert withDbus -> dbus != null;

with stdenv.lib;
let
  copts = [ ]
    ++ optional withDnssec "DNSSEC"
    ++ optional withConntrack "CONNTRACK"
    ++ optional withDbus "DBUS";
in
stdenv.mkDerivation rec {
  name = "dnsmasq-2.71";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/dnsmasq/${name}.tar.gz";
    sha256 = "1i1l2s2bcs6yx05wh1p2rf4bl0jfdgmg77b33gh44r1rdbv6933x";
  };

  buildInputs = [ pkgconfig ]
    ++ optionals withConntrack [ libnetfilter_conntrack libnfnetlink ]
    ++ optional withDbus dbus
    ++ optional withDnssec nettle;

  buildPhase = ''
    make COPTS="${concatStringsSep " " (map (n: "-DHAVE_${n}") copts)}"
  '';

  installFlags = [
    "DESTDIR= "
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/man"
    "LOCALEDIR=$(out)/share/locale"
  ];

  meta = {
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eelco ];
  };
}
