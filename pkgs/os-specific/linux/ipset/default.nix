{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "ipset-6.27";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${name}.tar.bz2";
    sha256 = "0ddj66wr0xh9v6ks430l8r80lj2s9qc44d9c2ik48lwm0fl9fj3j";
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
