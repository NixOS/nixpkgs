{ lib, stdenv, fetchurl, pam, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "duo-unix";
  version = "2.0.3";

  src = fetchurl {
    url    = "https://dl.duosecurity.com/duo_unix-${version}.tar.gz";
    sha256 = "sha256-O04mLmE/A6gmS1BLZ1MnDNTeoqBkkFJ/0GY9zGyXDeE=";
  };

  buildInputs = [ pam openssl zlib ];
  configureFlags =
    [ "--with-pam=$(out)/lib/security"
      "--prefix=$(out)"
      "--sysconfdir=$(out)/etc/duo"
      "--with-openssl=${openssl.dev}"
      "--enable-lib64=no"
    ];

  meta = {
    description = "Duo Security Unix login integration";
    homepage    = "https://duosecurity.com";
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
