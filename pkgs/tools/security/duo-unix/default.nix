{ stdenv, fetchurl, pam, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "duo-unix-${version}";
  version = "1.10.4";

  src = fetchurl {
    url    = "https://dl.duosecurity.com/duo_unix-${version}.tar.gz";
    sha256 = "1pbl6ii7sh66i277s5mqpnv092jd2q52qis3ar4lwy4mywfvrhjp";
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
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
