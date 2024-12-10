{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml,
}:

stdenv.mkDerivation rec {
  pname = "antsimulator";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "johnBuffer";
    repo = "AntSimulator";
    rev = "v${version}";
    sha256 = "sha256-1KWoGbdjF8VI4th/ZjAzASgsLEuS3xiwObulzxQAppA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml ];

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace "res/" "$out/opt/antsimulator/"

    substituteInPlace include/simulation/config.hpp \
      --replace "res/" "$out/opt/antsimulator/"

    substituteInPlace include/render/colony_renderer.hpp \
      --replace "res/" "$out/opt/antsimulator/"
  '';

  installPhase = ''
    install -Dm644 -t $out/opt/antsimulator res/*
    install -Dm755 ./AntSimulator $out/bin/antsimulator
  '';

  meta = with lib; {
    homepage = "https://github.com/johnBuffer/AntSimulator";
    description = "Simple Ants simulator";
    mainProgram = "antsimulator";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
