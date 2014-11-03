{ stdenv, fetchurl, autoconf, automake, libtool, wget, libpcap, gdbm, zlib, openssl, rrdtool
, python, geoip }:

stdenv.mkDerivation rec {
  name = "ntop-4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/ntop/${name}.tar.gz";
    sha256 = "19440gnswnqwvkbzpay9hzmnfnhbyc2ifpl2jri8dhcyhxima7n7";
  };

  preConfigure = ''
    ./autogen.sh
    cp ${libtool}/share/aclocal/libtool.m4 libtool.m4.in
  '';

  nativeBuildInputs = [ autoconf automake libtool wget libpcap gdbm zlib openssl rrdtool
    python geoip ];

  meta = {
    description = "Traffic analysis with NetFlow and sFlow support";
    license = stdenv.lib.licenses.gpl3Plus;
    homepage = http://www.ntop.org/products/ntop/;
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
