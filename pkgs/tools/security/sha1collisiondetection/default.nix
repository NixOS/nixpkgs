{ lib, stdenv, fetchFromGitHub, libtool, which }:

stdenv.mkDerivation  rec {
  pname = "sha1collisiondetection";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "cr-marcstevens";
    repo = "sha1collisiondetection";
    rev = "stable-v${version}";
    sha256 = "0xn31hkkqs0kj9203rzx6w4nr0lq8fnrlm5i76g0px3q4v2dzw1s";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  nativeBuildInputs = [ libtool which ];

  meta = with lib; {
    description = "Library and command line tool to detect SHA-1 collision";
    longDescription = ''
      This library and command line tool were designed as near drop-in
      replacements for common SHA-1 libraries and sha1sum. They will
      compute the SHA-1 hash of any given file and additionally will
      detect cryptanalytic collision attacks against SHA-1 present in
      each file. It is very fast and takes less than twice the amount
      of time as regular SHA-1.
      '';
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.mit;
  };
}
