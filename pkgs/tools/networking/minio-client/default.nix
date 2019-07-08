{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-client-${version}";

  version = "2019-01-30T19-57-22Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "1w0ig0daf0zxpkz449xq2hm7ajhzn8hlnnmpac6ip82qy53xnbm4";
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
