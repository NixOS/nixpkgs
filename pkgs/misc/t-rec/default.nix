{ lib, stdenv, imagemagick, ffmpeg, rustPlatform, fetchFromGitHub, makeWrapper
, libiconv, Foundation }:

let
  binPath = lib.makeBinPath [
    imagemagick
    ffmpeg
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "t-rec";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${version}";
    sha256 = "sha256-PvC1UaHt0ppGqVgouud/WKsP2CIGg+mbFN9VTiVy1RU=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ imagemagick ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Foundation ];

  postInstall = ''
    wrapProgram "$out/bin/t-rec" --prefix PATH : "${binPath}"
  '';

  cargoSha256 = "sha256-2EMxa39mIRN37U/v9+MMIGFRLOdkFeD+pVqoXU4f0kU=";

  meta = with lib; {
    description = "Blazingly fast terminal recorder that generates animated gif images for the web written in rust";
    homepage = "https://github.com/sassman/t-rec-rs";
    license = with licenses; [ gpl3Only ];
    maintainers = [ maintainers.hoverbear ];
  };
}
