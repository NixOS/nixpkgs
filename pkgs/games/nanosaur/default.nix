{ lib, stdenv, fetchFromGitHub, SDL2, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "nanosaur";
  version = "unstable-2021-12-03";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = "b567a3e6d7fd1cbc43800cfaa1bd82f31c6d9fae";
    sha256 = "sha256-P/o6uSwUV6O8u8XNXN9YyA8XlgEUkqGj3SC+oD2/GKQ=";
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
    mkdir -p "$out/share/Nanosaur"
    mv Data ReadMe.txt "$out/share/Nanosaur/"
    install -Dm755 {.,$out/bin}/Nanosaur
    wrapProgram $out/bin/Nanosaur --chdir "$out/share/Nanosaur"
    install -Dm644 $src/packaging/nanosaur.desktop $out/share/applications/nanosaur.desktop
    install -Dm644 $src/packaging/nanosaur-desktopicon.png $out/share/pixmaps/nanosaur-desktopicon.png
    runHook postInstall
  '';

  meta = with lib; {
    description = "A port of Nanosaur, a 1998 Macintosh game by Pangea Software, for modern operating systems";
    longDescription = ''
      Nanosaur is a 1998 Macintosh game by Pangea Software.
      In it, you’re a cybernetic dinosaur from the future who’s sent back in time 20 minutes before a giant asteroid hits the Earth.
      And you get to shoot at T-Rexes with nukes.
    '';
    homepage = "https://github.com/jorio/Nanosaur";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
  };
}
