{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio";
  version = "2021-03-10T05-11-33Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "sha256-YwlVZE7TO9qr/8lwLXdZqjxy4NGxTkmLyKFDVlTZPqQ=";
  };

  vendorSha256 = "sha256-E+j+ysBKKSyTITmJwHieBcpXdF3+rtt4YS7OVPMC6vI=";

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
