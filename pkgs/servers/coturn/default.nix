{ stdenv, fetchFromGitHub, fetchpatch, openssl, libevent }:

stdenv.mkDerivation rec {
  pname = "coturn";
  version = "4.5.1.2";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = version;
    sha256 = "01y65az8qyv2kjnb4fj7rgl4zq5pc2b286gfn727x3hfhksx9zp2";
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
