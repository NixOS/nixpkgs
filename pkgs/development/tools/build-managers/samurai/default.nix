{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "samurai";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = pname;
    rev = version;
    sha256 = "sha256-RPY3MFlnSDBZ5LOkdWnMiR/CZIBdqIFo9uLU+SAKPBI=";
  };

  makeFlags = [ "DESTDIR=" "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "ninja-compatible build tool written in C";
    homepage = "https://github.com/michaelforney/samurai";
    license = with licenses; [ mit asl20 ]; # see LICENSE
    maintainers = with maintainers; [ dtzWill ];
  };
}

