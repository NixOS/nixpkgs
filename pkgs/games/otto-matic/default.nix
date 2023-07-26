{ lib, stdenv, fetchFromGitHub, SDL2, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "OttoMatic";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = version;
    sha256 = "sha256-0mqOAdAmJGxKa6yXktrbmdXkoQIliimq37iy9bCBZYg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    SDL2
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mkdir -p "$out/share/OttoMatic"
    mv Data ReadMe.txt "$out/share/OttoMatic/"
    install -Dm755 {.,$out/bin}/OttoMatic
    wrapProgram $out/bin/OttoMatic --chdir "$out/share/OttoMatic"
    install -Dm644 $src/packaging/io.jor.ottomatic.desktop $out/share/applications/io.jor.ottomatic.desktop
    install -Dm644 $src/packaging/io.jor.ottomatic.png $out/share/pixmaps/io.jor.ottomatic.png
    runHook postInstall
  '';

  meta = with lib; {
    description = "A port of Otto Matic, a 2001 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/OttoMatic";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
  };
}
