{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "ipset-6.24";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${name}.tar.bz2";
    sha256 = "1l4mx78473azf7cb19fxf37gmj95k1zzabimbcmlg9h07wlgqw9h";
  };

  buildInputs = [ pkgconfig libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with stdenv.lib; {
    homepage = http://ipset.netfilter.org/;
    description = "Administration tool for IP sets";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
