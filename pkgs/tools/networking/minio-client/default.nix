{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio-client";
  version = "2021-01-16T02-45-34Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-1JUCoeLFMDvzT5KdQw+ZdYWPgdWKIL3kJ/LCIsqc6xE=";
  };

  vendorSha256 = "sha256-3wWUIFpNXom2MuUEDgAAEHlWRXhUzId+shZW/i5Rw4A=";

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
