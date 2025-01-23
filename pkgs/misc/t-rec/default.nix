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
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "sassman";
    repo = "t-rec-rs";
    rev = "v${version}";
    sha256 = "sha256-lOsagLiaGRvJKtBJAfDgmtZvPSF2EAdGrVXSPQCj7zs=";
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
  cargoHash = "sha256-2ErXqQ1vRsPMJPFqdAlrmdPTuEC/h5L+DvGJf2K0ziw=";

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
