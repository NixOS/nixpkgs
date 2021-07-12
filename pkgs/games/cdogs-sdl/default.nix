{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL2
, SDL2_image
, SDL2_mixer
, cmake
, gtk3-x11
, python3
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "cdogs";
  version = "0.12.0";

  src = fetchFromGitHub {
    repo = "cdogs-sdl";
    owner = "cxong";
    rev = version;
    sha256 = "sha256-qbMR7otsC+uz+9mwgFaD2Z5fC6rj8ueYG3KwpPiqL98=";
  };

  postPatch = ''
    patchShebangs src/proto/nanopb/generator/*
  '';

  cmakeFlags = [ "-DCDOGS_DATA_DIR=${placeholder "out"}/" ];

  nativeBuildInputs = [
    pkg-config
    cmake
    (python3.withPackages (pp: with pp; [ pp.protobuf setuptools ]))
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    gtk3-x11
    protobuf
  ];

  meta = with lib; {
    homepage = "https://cxong.github.io/cdogs-sdl";
    description = "Open source classic overhead run-and-gun game";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nixinator ];
    platforms = platforms.unix;
  };
}
