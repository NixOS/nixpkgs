{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-2.0.0-b8";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "1slkv1hhcp9a6c88h6yl5cs0z9g60fp2ja6865s6kywqp6fmf168";
  };

  buildInputs = [ openssl ];

  configureFlags = stdenv.lib.optionalString stdenv.isDarwin "--disable-ip6";

  meta = {
    description = "A utility for bidirectional data transfer between two independent data channels";
    homepage = http://www.dest-unreach.org/socat/;
    repositories.git = git://repo.or.cz/socat.git;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
