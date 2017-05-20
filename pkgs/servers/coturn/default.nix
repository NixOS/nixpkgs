{ stdenv, fetchFromGitHub, openssl, libevent }:

let inherit (stdenv.lib) optional; in

stdenv.mkDerivation rec {
  name = "coturn-${version}";
  version = "4.5.0.6";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = "${version}";
    sha256 = "084c3zgwmmz4s6211i5jbkzsn13703lsg7vhc2cpacazq4sgsrhb";
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
