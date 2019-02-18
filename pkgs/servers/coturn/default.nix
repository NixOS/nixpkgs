{ stdenv, fetchFromGitHub, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "coturn-${version}";
  version = "4.5.1.0";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = "${version}";
    sha256 = "16fp9vppdz825949vpqi82iwscc2k4gajw1kl2p9pf3d3mv1flsk";
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
