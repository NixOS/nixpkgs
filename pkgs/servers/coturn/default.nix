{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, openssl
, libevent
, libprom
}:

stdenv.mkDerivation rec {
  pname = "coturn";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "coturn";
    repo = "coturn";
    rev = version;
    sha256 = "1s7ncc82ny4bb3qkn3fqr0144xsr7h2y8xmzsf5037h6j8f7j3v8";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl libevent libprom ];

  patches = [
    ./pure-configure.patch
  ];

  meta = with lib; {
    homepage = "https://coturn.net/";
    license = with licenses; [ bsd3 ];
    description = "A TURN server";
    platforms = platforms.all;
    broken = stdenv.isDarwin; # 2018-10-21
    maintainers = [ maintainers.ralith ];
  };
}
