{ stdenv, fetchurl, pam, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "duo-unix-${version}";
  version = "1.9.11";

  src = fetchurl {
    url    = "https://dl.duosecurity.com/duo_unix-${version}.tar.gz";
    sha256 = "0747avzmzzz1gaisahgjlpxyxxbrn04w1mip90lfj9wp2x6a9jgm";
  };

  buildInputs = [ pam openssl zlib ];
  configureFlags =
    [ "--with-pam=$(out)/lib/security"
      "--prefix=$(out)"
      "--sysconfdir=$(out)/etc/duo"
      "--with-openssl=${openssl}"
      "--enable-lib64=no"
    ];

  meta = {
    description = "Duo Security Unix login integration";
    homepage    = "https://duosecurity.com";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
