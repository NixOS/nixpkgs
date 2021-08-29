{ lib, stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge, SkyLight }:

stdenv.mkDerivation rec {
  pname = "spacebar";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "cmacrae";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f5ddn3sx13rwwh0nfl784160s8ml3m5593d5fz2b1996aznzrsx";
  };

  buildInputs = [ Carbon Cocoa ScriptingBridge SkyLight ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/spacebar $out/bin/spacebar
    cp ./doc/spacebar.1 $out/share/man/man1/spacebar.1
  '';

  meta = with lib; {
    description = "A minimal status bar for macOS";
    homepage = "https://github.com/cmacrae/spacebar";
    platforms = platforms.darwin;
    maintainers = [ maintainers.cmacrae ];
    license = licenses.mit;
  };
}
