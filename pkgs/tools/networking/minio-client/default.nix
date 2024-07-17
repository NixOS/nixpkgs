{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "minio-client";
  version = "2024-05-09T17-04-24Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-S7bi7BTbsbXUFoDpm0IhOvjnumcKbewV0celUxAx57g=";
  };

  vendorHash = "sha256-vqPSzzNIvy+9J9bPE4hxWvRPuPKpB8ahuu6ENnFmfJ0=";

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
    maintainers = with maintainers; [
      bachp
      eelco
    ];
    mainProgram = "mc";
    license = licenses.asl20;
  };
}
