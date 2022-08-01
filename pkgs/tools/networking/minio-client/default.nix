{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio-client";
  version = "2022-07-24T02-25-13Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-wBAZD2qX/EoAgUVPdBJrPJe4Na6yPgjoJeKGBqwYJzs=";
  };

  vendorSha256 = "sha256-F/BNi8DA2NbAE0lUn63DzNeFDXY9hBeIgSv6XBb4cCc=";

  subPackages = [ "." ];

  patchPhase = ''
    sed -i "s/Version.*/Version = \"${version}\"/g" cmd/build-constants.go
    sed -i "s/ReleaseTag.*/ReleaseTag = \"RELEASE.${version}\"/g" cmd/build-constants.go
    sed -i "s/CommitID.*/CommitID = \"${src.rev}\"/g" cmd/build-constants.go
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/mc --version | grep ${version} > /dev/null
  '';

  passthru.tests.minio = nixosTests.minio;

  meta = with lib; {
    homepage = "https://github.com/minio/mc";
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ bachp eelco ];
    mainProgram = "mc";
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
