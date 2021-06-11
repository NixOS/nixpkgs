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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${version}";
    sha256 = "InArrBqfhDrsonjmCIPTBVOA/s2vYml9Ay6cdrKLd7c=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ imagemagick ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Foundation ];

  postInstall = ''
    wrapProgram "$out/bin/t-rec" --prefix PATH : "${binPath}"
  '';

  cargoSha256 = "4gwfrC65YlXV6Wu2ninK1TvMNUkY1GstVYPr0FK+xLU=";

  meta = with lib; {
    description = "Blazingly fast terminal recorder that generates animated gif images for the web written in rust";
    homepage = "https://github.com/sassman/t-rec-rs";
    license = with licenses; [ gpl3Only ];
    maintainers = [ maintainers.hoverbear ];
  };
}
