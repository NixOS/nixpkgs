{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "ipset-6.38";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${name}.tar.bz2";
    sha256 = "0i72wcljl0nkpmzc20jcch3hpphrm0qp4v4j4ajamq0zlddn5vyf";
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
