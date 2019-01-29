{ stdenv, fetchurl, ppp } :
let
  version = "3.12";
in
stdenv.mkDerivation rec {
  name = "rp-pppoe-" + version;
  src = fetchurl {
    url = "https://www.roaringpenguin.com/files/download/rp-pppoe-${version}.tar.gz";
    sha256 = "1hl6rjvplapgsyrap8xj46kc9kqwdlm6ya6gp3lv0ihm0c24wy80";
  };

  buildInputs = [ ppp ];


  preConfigure = ''
    cd src
    export PPPD=${ppp}/sbin/pppd
  '';
  postConfigure = ''
    sed -i Makefile -e 's@DESTDIR)/etc/ppp@out)/etc/ppp@'
    sed -i Makefile -e 's@PPPOESERVER_PPPD_OPTIONS=@&$(out)@'
  '';

  meta = with stdenv.lib; {
    description = "Roaring Penguin Point-to-Point over Ethernet tool";
    platforms = platforms.linux;
    homepage = https://www.roaringpenguin.com/products/pppoe;
    license = licenses.gpl2Plus;
  };
}
