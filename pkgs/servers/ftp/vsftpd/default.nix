{ stdenv, fetchurl, openssl, sslEnable ? false, libcap, pam }:

stdenv.mkDerivation rec {
  name = "vsftpd-3.0.3";

  src = fetchurl {
    url = "https://security.appspot.com/downloads/${name}.tar.gz";
    sha256 = "1xsyjn68k3fgm2incpb3lz2nikffl9by2safp994i272wvv2nkcx";
  };

  patches = [ ./CVE-2015-1419.patch ];

  preConfigure = stdenv.lib.optionalString sslEnable ''
    echo "Will enable SSL"
    sed -i "/VSF_BUILD_SSL/s/^#undef/#define/" builddefs.h
  '';

  # The gcc-wrappers use -idirafter for glibc, and vsftpd also, and
  # their dummyinc come before those of glibc, then the build works bad.
  prePatch = ''
    sed -i -e 's/-idirafter.*//' Makefile
  '';

  preBuild =
    let
      sslLibs = if sslEnable then "-lcrypt -lssl -lcrypto" else "";
    in ''
      makeFlagsArray=( "LIBS=${sslLibs} -lpam -lcap -fstack-protector" )
    '';

  # It won't link without this flag, used in CFLAGS

  buildInputs = [ openssl libcap pam ];

  installPhase = ''
    mkdir -pv $out/sbin
    install -v -m 755 vsftpd $out/sbin/vsftpd

    mkdir -pv $out/share/man/man{5,8}
    install -v -m 644 vsftpd.8 $out/share/man/man8/vsftpd.8
    install -v -m 644 vsftpd.conf.5 $out/share/man/man5/vsftpd.conf.5

    mkdir -pv $out/etc/xinetd.d
    install -v -m 644 xinetd.d/vsftpd $out/etc/xinetd.d/vsftpd
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
