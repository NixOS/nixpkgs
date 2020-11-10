{ stdenv, fetchFromGitHub, fetchpatch, openssl, libevent }:

stdenv.mkDerivation rec {
  pname = "coturn";
  version = "4.5.1.3";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = version;
    sha256 = "1801931k4qdvc7jvaqxvjyhbh1xsvjz0pjajf6xc222n4ggar1q5";
  };

  buildInputs = [ openssl libevent ];

  patches = [
    ./pure-configure.patch
  ];

  meta = with stdenv.lib; {
    homepage = "https://coturn.net/";
    license = with licenses; [ bsd3 ];
    description = "A TURN server";
    platforms = platforms.all;
    broken = stdenv.isDarwin; # 2018-10-21
    maintainers = [ maintainers.ralith ];
  };
}
