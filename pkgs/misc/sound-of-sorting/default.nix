{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL2
, wxGTK32
, darwin
}:

stdenv.mkDerivation {
  pname = "sound-of-sorting";
  version = "unstable-2022-10-12";

  src = fetchFromGitHub {
    owner = "bingmann";
    repo = "sound-of-sorting";
    rev = "5cfcaf752593c8cbcf52555dd22745599a7d8b1b";
    hash = "sha256-cBrTvFoz6WZIsh5qPPiWxQ338Z0OfcIefiI8CZF6nn8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wxGTK32
    SDL2
  ]
  ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa ;

  meta = {
    description = "Audibilization and Visualization of Sorting Algorithms";
    homepage = "https://panthema.net/2013/sound-of-sorting/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
}
