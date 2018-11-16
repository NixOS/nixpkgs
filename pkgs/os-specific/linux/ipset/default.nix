{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "ipset-7.0";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${name}.tar.bz2";
    sha256 = "1bs1qz6cs9z167f36xsbg93fb6dj5bw05shk07fkwkjiglxhzyn6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with stdenv.lib; {
    homepage = http://ipset.netfilter.org/;
    description = "Administration tool for IP sets";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
