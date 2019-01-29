{ stdenv, fetchFromGitHub, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "coturn-${version}";
  version = "4.5.0.8";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = "${version}";
    sha256 = "1l2q76lzv2gff832wrqd9dcilyaqx91pixyz335822ypra89mdp8";
  };

  buildInputs = [ openssl libevent ];

  patches = [ ./pure-configure.patch ];

  meta = with stdenv.lib; {
    homepage = http://coturn.net/;
    license = with licenses; [ bsd3 ];
    description = "A TURN server";
    platforms = platforms.all;
    broken = stdenv.isDarwin; # 2018-10-21
    maintainers = [ maintainers.ralith ];
  };
}
