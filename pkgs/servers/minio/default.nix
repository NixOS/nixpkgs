{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio";
  version = "2021-01-16T02-19-44Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "sha256-eYOarXgx5+rXCw2gMzrH1vVSsIdN4WrHrAUnnCcLtN8=";
  };

  vendorSha256 = "sha256-6p/DBgHawsT5PjpzwjrKgZfWm5Z6v1ozMWzGpEiB2jM=";

  doCheck = false;

  subPackages = [ "." ];

  patchPhase = ''
    sed -i "s/Version.*/Version = \"${version}\"/g" cmd/build-constants.go
    sed -i "s/ReleaseTag.*/ReleaseTag = \"RELEASE.${version}\"/g" cmd/build-constants.go
    sed -i "s/CommitID.*/CommitID = \"${src.rev}\"/g" cmd/build-constants.go
  '';

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  buildFlagsArray = [
    "-tags=kqueue"
  ];

  passthru.tests.minio = nixosTests.minio;

  meta = with lib; {
    homepage = "https://www.minio.io/";
    description = "An S3-compatible object storage server";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
