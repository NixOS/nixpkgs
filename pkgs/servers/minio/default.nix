{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

let
  # The web client verifies, that the server version is a valid datetime string:
  # https://github.com/minio/minio/blob/3a0e7347cad25c60b2e51ff3194588b34d9e424c/browser/app/js/web.js#L51-L53
  #
  # Example:
  #   versionToTimestamp "2021-04-22T15-44-28Z"
  #   => "2021-04-22T15:44:28Z"
  versionToTimestamp = version:
    let
      splitTS = builtins.elemAt (builtins.split "(.*)(T.*)" version) 1;
    in
    builtins.concatStringsSep "" [ (builtins.elemAt splitTS 0) (builtins.replaceStrings [ "-" ] [ ":" ] (builtins.elemAt splitTS 1)) ];

  # CopyrightYear will be printed to the CLI UI.
  # Example:
  #   versionToYear "2021-04-22T15-44-28Z"
  #   => "2021"
  versionToYear = version: builtins.elemAt (lib.splitString "-" version) 0;
in
buildGoModule rec {
  pname = "minio";
  version = "2024-06-13T22-53-53Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    hash = "sha256-SqrL1fYVy7OylepQGmTm6p77q3vssNdWyJ5+9wZHehQ=";
  };

  vendorHash = "sha256-AK6PGX/ezkN/LAnOLd8fRGkzwhTE4BY63H9ebnXxEOA=";

  doCheck = false;

  subPackages = [ "." ];

  CGO_ENABLED = 0;

  tags = [ "kqueue" ];

  ldflags = let t = "github.com/minio/minio/cmd"; in [
    "-s"
    "-w"
    "-X ${t}.Version=${versionToTimestamp version}"
    "-X ${t}.CopyrightYear=${versionToYear version}"
    "-X ${t}.ReleaseTag=RELEASE.${version}"
    "-X ${t}.CommitID=${src.rev}"
  ];

  passthru.tests.minio = nixosTests.minio;

  meta = with lib; {
    homepage = "https://www.minio.io/";
    description = "S3-compatible object storage server";
    changelog = "https://github.com/minio/minio/releases/tag/RELEASE.${version}";
    maintainers = with maintainers; [ eelco bachp ];
    license = licenses.agpl3Plus;
    mainProgram = "minio";
  };
}
