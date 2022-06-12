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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${version}";
    sha256 = "sha256-rVlNyvSeiQbauf8CREJDmb02wv6b/4IeOerRCRWVQVA=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ imagemagick ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Foundation ];

  postInstall = ''
    wrapProgram "$out/bin/t-rec" --prefix PATH : "${binPath}"
  '';

  cargoSha256 = "sha256-pcdvEHxqU6ZJwcsbnQEd9M0waK7y4aluYEpLIlZoK/s=";

  meta = with lib; {
    description = "Blazingly fast terminal recorder that generates animated gif images for the web written in rust";
    homepage = "https://github.com/sassman/t-rec-rs";
    license = with licenses; [ gpl3Only ];
    maintainers = [ maintainers.hoverbear ];
  };
}
