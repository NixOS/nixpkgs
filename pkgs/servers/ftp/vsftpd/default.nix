{ stdenv, fetchurl, libcap, openssl, pam }:

stdenv.mkDerivation rec {
  name = "vsftpd-3.0.3";

  src = fetchurl {
    url = "https://security.appspot.com/downloads/${name}.tar.gz";
    sha256 = "1xsyjn68k3fgm2incpb3lz2nikffl9by2safp994i272wvv2nkcx";
  };

  buildInputs = [ libcap openssl pam ];

  patches = [ ./CVE-2015-1419.patch ];

  postPatch = ''
    sed -i "/VSF_BUILD_SSL/s/^#undef/#define/" builddefs.h

    substituteInPlace Makefile \
      --replace -dirafter "" \
      --replace /usr $out \
      --replace /etc $out/etc

    mkdir -p $out/sbin $out/man/man{5,8}
  '';

  NIX_LDFLAGS = "-lcrypt -lssl -lcrypto -lpam -lcap";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A very secure FTP daemon";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
