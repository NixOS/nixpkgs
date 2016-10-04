{ stdenv, fetchurl, fetchpatch, openssl, lzo, zlib, yacc, flex }:

stdenv.mkDerivation rec {
  name = "vtun-3.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/vtun/${name}.tar.gz";
    sha256 = "1jxrxp3klhc8az54d5qn84cbc0vdafg319jh84dxkrswii7vxp39";
  };

  patches = [
    (fetchpatch { url = http://sources.debian.net/data/main/v/vtun/3.0.3-2.2/debian/patches/08-gcc5-inline.patch;
                 sha256 = "18sys97v2hx6vac5zp3ld7sa6kz4izv3g9dnkm0lflbaxhym2vs1";
                })
  ];

  postPatch = ''
    sed -i -e 's/-m 755//' -e 's/-o root -g 0//' Makefile.in
    sed -i '/strip/d' Makefile.in
  '';
  buildInputs = [ lzo openssl zlib yacc flex ];

  configureFlags = ''
    --with-lzo-headers=${lzo}/include/lzo
    --with-ssl-headers=${openssl.dev}/include/openssl
    --with-blowfish-headers=${openssl.dev}/include/openssl'';

  meta = with stdenv.lib; {
      description = "Virtual Tunnels over TCP/IP with traffic shaping, compression and encryption";
      homepage = http://vtun.sourceforge.net/;
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ pSub ];
  };
}
