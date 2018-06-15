{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-client-${version}";

  version = "2018-04-28T00-08-20Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "03c9ahphkpsy6z9i9z50jcsgj5ba6gba2sw2nz22b1ynqiz3ds37";
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
