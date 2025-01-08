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
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${version}";
    sha256 = "sha256-o1fO0N65L6Z6W6aBNhS5JqDHIc1MRQx0yECGzVSCsbo=";
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

  cargoHash = "sha256-3NExPlHNcoYVkpOzWCyd66chJpeDzQLRJUruSLAwGNw=";

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
