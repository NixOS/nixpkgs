{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "socat-2.0.0-b9";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${name}.tar.bz2";
    sha256 = "1ll395xjv4byvv0k2zjbxk8vp3mg3y2w5paa05wv553bqsjv1vs9";
  };

  buildInputs = [ openssl ];

  patches = stdenv.lib.singleton ./libressl-fixes.patch ;

  meta = with stdenv.lib; {
    description = "A utility for bidirectional data transfer between two independent data channels";
    homepage = http://www.dest-unreach.org/socat/;
    repositories.git = git://repo.or.cz/socat.git;
    platforms = platforms.unix;
    license = licenses.gpl2;
    maintainers = [ maintainers.eelco ];
  };
}
