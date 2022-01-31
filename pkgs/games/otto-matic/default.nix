{ lib, stdenv, fetchFromGitHub, SDL2, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "OttoMatic";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = version;
    sha256 = "sha256:1yd4clks7kr2hn69c4q1ykc92sw6axbspambm03viapr834bjz3q";
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

    mkdir -p $out/share/OttoMatic
    mv Data $out/share/OttoMatic
    install -Dm755 {.,$out/bin}/OttoMatic
    wrapProgram $out/bin/OttoMatic --run "cd $out/share/OttoMatic"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A port of Otto Matic, a 2001 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/OttoMatic";
    license = with licenses; [
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
  };
}
