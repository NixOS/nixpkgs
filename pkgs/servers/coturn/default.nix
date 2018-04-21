{ stdenv, fetchFromGitHub, openssl, libevent }:

let inherit (stdenv.lib) optional; in

stdenv.mkDerivation rec {
  name = "coturn-${version}";
  version = "4.5.0.7";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = "${version}";
    sha256 = "1781fx8lqgc54j973xzgq9d7k3g2j03va82jb4217gd3a93pa65l";
  };

  buildInputs = [ openssl libevent ];

  patches = [ ./pure-configure.patch ];

  meta = with stdenv.lib; {
    homepage = http://coturn.net/;
    license = with licenses; [ bsd3 ];
    description = "A TURN server";
    platforms = platforms.all;
    maintainers = [ maintainers.ralith ];
  };
}
