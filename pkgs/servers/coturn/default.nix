{ stdenv, fetchFromGitHub, openssl, libevent }:

with { inherit (stdenv.lib) optional; };

stdenv.mkDerivation rec {
  name = "coturn-${version}";
  version = "4.5.0.3";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = "${version}";
    sha256 = "1xr4dp3p16m4rq9mdsprs6s50rnif6hk38xx9siyykgfjnwr6i9g";
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
