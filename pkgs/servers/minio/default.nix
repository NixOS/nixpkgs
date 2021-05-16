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
  version = "2021-05-11T23-27-41Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "0yljq4lm9maz73ha9m38ljv977999p57rfkzybgzbjjrijgszm2b";
  };

  vendorSha256 = "1dm8nbg86zvxakc7h4dafqb035sc5x6viz8p409l22l695qrp6bi";

  doCheck = false;

  subPackages = [ "." ];

  preBuild = let t = "github.com/minio/minio/cmd"; in
    ''
      export CGO_ENABLED=0
      buildFlagsArray+=("-tags" "kqueue" "-ldflags" "-s -w -X ${t}.Version=${versionToTimestamp version} -X ${t}.ReleaseTag=RELEASE.${version} -X ${t}.CommitID=${src.rev}")
    '';

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
