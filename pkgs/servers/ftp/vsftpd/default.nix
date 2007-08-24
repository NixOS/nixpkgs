{stdenv, fetchurl, openssl}:

stdenv.mkDerivation {
  name = "vsftpd-2.0.3";
  src = fetchurl {
    url = ftp://vsftpd.beasts.org/users/cevans/vsftpd-2.0.3.tar.gz;
    md5 = "74936cbd8e8251deb1cd99c5fb18b6f8" ;
  };
  
  NIX_LDFLAGS = [ "-lcrypt" "-lssl" "-lcrypto" ];

  builder = ./builder.sh ;

  patches = [ ./fix.patch ] ;
  buildInputs = [ openssl ];
}
