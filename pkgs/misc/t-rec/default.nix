{
  lib,
  stdenv,
  imagemagick,
  ffmpeg,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  libiconv,
  Foundation,
}:

let
  binPath = lib.makeBinPath [
    imagemagick
    ffmpeg
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "t-rec";
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${version}";
    sha256 = "sha256-aQX+JJ2MwzzxJkA1vsE8JqvYpWtqyycvycPc2pyFU7g=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs =
    [ imagemagick ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Foundation
    ];

  postInstall = ''
    wrapProgram "$out/bin/t-rec" --prefix PATH : "${binPath}"
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-AgSYM2a9XGH2X4dcp5CSMnt0Bq/5XT8C3g1R2UX4mLY=";

  meta = with lib; {
    description = "Blazingly fast terminal recorder that generates animated gif images for the web written in rust";
    homepage = "https://github.com/sassman/t-rec-rs";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [
      hoverbear
      matthiasbeyer
    ];
    mainProgram = "t-rec";
  };
}
