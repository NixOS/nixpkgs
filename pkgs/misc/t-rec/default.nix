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
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${version}";
    sha256 = "sha256-111zbUDmp/Yyvx0uXMzqEnk/Jr2hfxtNNX6f0Ti3Brg=";
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

  cargoHash = "sha256-fjq4Bys7KnSu6kV74CZJ95oov4HXY59VltjcAuXGMPg=";

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
