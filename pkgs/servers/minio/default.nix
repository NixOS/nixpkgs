{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

let
  # The web client verifies, that the server version is a valid datetime string:
  # https://github.com/minio/minio/blob/3a0e7347cad25c60b2e51ff3194588b34d9e424c/browser/app/js/web.js#L51-L53
  #
  # Example:
  #   versionToTimestamp "2021-04-22T15-44-28Z"
  #   => "2021-04-22T15:44:28Z"
  versionToTimestamp =
    version:
    let
      splitTS = builtins.elemAt (builtins.split "(.*)(T.*)" version) 1;
    in
    builtins.concatStringsSep "" [
      (builtins.elemAt splitTS 0)
      (builtins.replaceStrings [ "-" ] [ ":" ] (builtins.elemAt splitTS 1))
    ];

  # CopyrightYear will be printed to the CLI UI.
  # Example:
  #   versionToYear "2021-04-22T15-44-28Z"
  #   => "2021"
  versionToYear = version: builtins.elemAt (lib.splitString "-" version) 0;
in
buildGoModule rec {
  pname = "minio";
  version = "2025-06-13T11-33-47Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    hash = "sha256-pck/K/BJZC0OdjgeCr+3ErkOyqmVTCdZv61jG24tp2E=";
  };

  vendorHash = "sha256-0UoEIlxbAveYlCbGZ2z1q+RAksJrVjdE+ymc6ozDGcE=";

  doCheck = false;

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  tags = [ "kqueue" ];

  ldflags =
    let
      t = "github.com/minio/minio/cmd";
    in
    [
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
    maintainers = with maintainers; [
      bachp
      ryan4yin
    ];
    license = licenses.agpl3Plus;
    mainProgram = "minio";
  };
}
