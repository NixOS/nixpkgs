{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-client-${version}";

  version = "2018-12-27T00-37-49Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "1hbw3yam5lc9414f3f8yh32ycj0wz2xc934ksvjnrhkk4xzyal6h";
  };

  goPackagePath = "github.com/minio/mc";

  buildFlagsArray = [''-ldflags=
    -X github.com/minio/mc/cmd.Version=${version}
  ''];

  meta = with stdenv.lib; {
    homepage = https://github.com/minio/mc;
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
