{ lib, stdenv, fetchFromGitHub, Foundation }:

stdenv.mkDerivation rec {
  pname = "defaultbrowser";
  version = "unstable-2020-07-23";

  src = fetchFromGitHub {
    owner = "kerma";
    repo = pname;
    rev = "d2860c00dd7fbb5d615232cc819d7d492a6a6ddb";
    sha256 = "sha256-SelUQXoKtShcDjq8uKg3wM0kG2opREa2DGQCDd6IsOQ=";
  };

  makeFlags = [ "CC=cc" "PREFIX=$(out)" ];

  buildInputs = [ Foundation ];

  meta = with lib; {
    mainProgram = "defaultbrowser";
    description = "Command line tool for getting and setting a default browser (HTTP handler) in Mac OS X";
    homepage = "https://github.com/kerma/defaultbrowser";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ Enzime ];
    license = licenses.mit;
  };
}
