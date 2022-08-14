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
in
buildGoModule rec {
  pname = "minio";
  version = "2022-08-13T21-54-44Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "sha256-+N/IFVyidbu4ns9Pw27D8lxAeSk+KpIIRZOkfxlJQ+Q=";
  };

  vendorSha256 = "sha256-spWmI2an9NW5iMWw7yPDZQ2s0iVjNqnbRY867bBBwAE=";

  doCheck = false;

  subPackages = [ "." ];

  CGO_ENABLED = 0;

  tags = [ "kqueue" ];

  ldflags = let t = "github.com/minio/minio/cmd"; in [
    "-s" "-w" "-X ${t}.Version=${versionToTimestamp version}" "-X ${t}.ReleaseTag=RELEASE.${version}" "-X ${t}.CommitID=${src.rev}"
  ];

  passthru.tests.minio = nixosTests.minio;

  meta = with lib; {
    homepage = "https://www.minio.io/";
    description = "An S3-compatible object storage server";
    changelog = "https://github.com/minio/minio/releases/tag/RELEASE.${version}";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.agpl3Plus;
  };
}
