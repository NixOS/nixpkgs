{ lib, stdenv, fetchfossil, openssl }:

stdenv.mkDerivation rec {
  pname = "althttpd";
  version = "unstable-2022-01-10";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "83196564d05f33c3";
    sha256 = "sha256-z/XMVnDihcO56kJaXIJGUUdnz8mR5jlySrLZX1tkV5c=";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    install -Dm755 -t $out/bin althttpd
  '';

  meta = with lib; {
    description = "The Althttpd webserver";
    homepage = "https://sqlite.org/althttpd/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };
}
