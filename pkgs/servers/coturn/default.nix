{ stdenv, fetchFromGitHub, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "coturn-${version}";
  version = "4.5.1.1";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = "${version}";
    sha256 = "12x604lgva1d3g4wvl3f66rdj6lkjk5cqr0l3xas33xgzgm13pwr";
  };

  buildInputs = [ openssl libevent ];

  patches = [ ./pure-configure.patch ];

  meta = with stdenv.lib; {
    homepage = https://coturn.net/;
    license = with licenses; [ bsd3 ];
    description = "A TURN server";
    platforms = platforms.all;
    broken = stdenv.isDarwin; # 2018-10-21
    maintainers = [ maintainers.ralith ];
  };
}
