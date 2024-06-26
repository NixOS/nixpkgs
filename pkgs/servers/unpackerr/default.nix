{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  Cocoa,
  WebKit,
}:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "sha256-K6ZDRDtxeqtjToElix1qVgclHaEeOY0W6hOwehFNIgo=";
  };

  vendorHash = "sha256-1OSZzs/hUvauRIE5lzlXPIS2EkHm4aNK1iddjKCb6zA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Cocoa
    WebKit
  ];

  ldflags = [
    "-s"
    "-w"
    "-X golift.io/version.Version=${version}"
  ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = with maintainers; [ nullx76 ];
    license = licenses.mit;
    mainProgram = "unpackerr";
  };
}
