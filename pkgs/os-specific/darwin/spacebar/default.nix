{
  lib,
  stdenv,
  fetchFromGitHub,
  Carbon,
  Cocoa,
  ScriptingBridge,
  SkyLight,
}:

stdenv.mkDerivation rec {
  pname = "spacebar";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "cmacrae";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4LiG43kPZtsm7SQ/28RaGMpYsDshCaGvc1mouPG3jFM=";
  };

  buildInputs = [
    Carbon
    Cocoa
    ScriptingBridge
    SkyLight
  ];

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
