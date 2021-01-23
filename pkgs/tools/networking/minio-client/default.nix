{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio-client";
  version = "2020-11-25T23-04-07Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "0r4za7jnwmh2wna5l4iv5pz6s5c62f7v4hmbv7misff9qbk4p4k7";
  };

  vendorSha256 = "0zracgqwhqs3gabrqqm8fm3hyicaadcinsjp5qgprjwd9a3c1zfv";

  doCheck = false;

  subPackages = [ "." ];

  patchPhase = ''
    sed -i "s/Version.*/Version = \"${version}\"/g" cmd/build-constants.go
    sed -i "s/ReleaseTag.*/ReleaseTag = \"RELEASE.${version}\"/g" cmd/build-constants.go
    sed -i "s/CommitID.*/CommitID = \"${src.rev}\"/g" cmd/build-constants.go
  '';

  meta = with lib; {
    homepage = "https://github.com/minio/mc";
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
