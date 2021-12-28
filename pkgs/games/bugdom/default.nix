{ lib, stdenv, fetchFromGitHub, SDL2, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "bugdom";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = version;
    sha256 = "sha256:1371inw11rzfrxmc3v4gv5axp56bxjbcr0mhqm4x839401bfq5mf";
    fetchSubmodules = true;
  };

  buildInputs = [
    SDL2
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/bugdom
    mv Data $out/share/bugdom
    install -Dm755 {.,$out/bin}/Bugdom
    wrapProgram $out/bin/Bugdom --run "cd $out/share/bugdom"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A port of Bugdom, a 1999 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/Bugdom";
    license = with licenses; [
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
  };
}
