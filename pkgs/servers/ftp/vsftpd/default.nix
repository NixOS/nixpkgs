{ stdenv, fetchurl, openssl, libcap, pam }:

stdenv.mkDerivation rec {
  name = "vsftpd-2.0.5";
  
  src = fetchurl {
    url = "ftp://vsftpd.beasts.org/users/cevans/${name}.tar.gz";
    sha256 = "0nzsxknnaqnfk853yjsmi31sl02jf5ydix9wxbldv4i7vzqfnqjl";
  };
  
  NIX_LDFLAGS = "-lcrypt -lssl -lcrypto -lpam -lcap";

  preInstall = ''
    ensureDir $out/{,s}bin
    ensureDir $out/man/man{5,8}
  '';

  patches = [ ./fix.patch ] ;
  
  preConfigure = ''
    sed -i "/VSF_BUILD_SSL/s/^#undef/#define/" builddefs.h
    sed -i "s@/etc/vsftpd.user_list@$out/vsftpd.user_list@" vsftpd.conf.5 tunables.c
  '';

  postInstall = "cp ${./vsftpd.user_list} $out/vsftpd.user_list";

  buildInputs = [ openssl libcap pam ];
}
