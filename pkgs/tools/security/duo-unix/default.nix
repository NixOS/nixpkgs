{ lib, stdenv, fetchurl, pam, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "duo-unix";
  version = "1.12.0";

  src = fetchurl {
    url    = "https://dl.duosecurity.com/duo_unix-${version}.tar.gz";
    sha256 = "sha256-i7oAmNjXkGn1MCn5EBmidMY/u3h/rzRAHCD4uhVGV/Q=";
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
