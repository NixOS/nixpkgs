{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio";
  version = "2021-02-01T22-56-52Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "sha256-cAQErFWFqyHJpTGxbzY5JCSH/ZV0ZZOWbh1lJmK8MlY=";
  };

  vendorSha256 = "sha256-1wnnt4QuOn+1NqZcuA43naP3KtIL5VbVr6VF3+Cu41w=";

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
