{ stdenv, lib, fetchFromGitHub, Cocoa }:

## after launching for the first time, grant access for parent application (e.g. Terminal.app)
## from 'system preferences >> security & privacy >> accessibility'
## and then launch again

stdenv.mkDerivation rec {
  pname = "discrete-scroll";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "emreyolcu";
    repo = "discrete-scroll";
    rev = "v${version}";
    sha256 = "0aqkp4kkwjlkll91xbqwf8asjww8ylsdgqvdk8d06bwdvg2cgvhg";
  };

  buildInputs = [ Cocoa ];

  buildPhase = ''
    cc -std=c99 -O3 -Wall -framework Cocoa -o dc DiscreteScroll/main.m
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./dc $out/bin/discretescroll
  '';

  meta = with lib; {
    description = "Fix for OS X's scroll wheel problem";
    homepage = "https://github.com/emreyolcu/discrete-scroll";
    platforms = platforms.darwin;
    license = licenses.mit;
    maintainers = with lib.maintainers; [ bb2020 ];
  };
}
