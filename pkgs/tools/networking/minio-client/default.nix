{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio-client";
  version = "2022-08-23T05-45-20Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-ecEoMyTdL1ckKAPPTrXHDbzB5778Jq11yqQ/UJi6yuQ=";
  };

  vendorSha256 = "sha256-pq6tiVrkpf7anYAhkc0y+AB8qhqSPR93HME8AbN/cz0=";

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
