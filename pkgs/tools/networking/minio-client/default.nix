{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-client-${version}";

  version = "2018-07-31T02-28-53Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "1918yl5d92y4ij9d1v738pf574rwb6a911rjpmaj9awhrz8qa2bg";
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
