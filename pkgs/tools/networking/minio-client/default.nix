{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-client-${version}";

  version = "2018-03-25T01-22-22Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "1x71va37jaqsi99d0i0mccybrs9kjgmpfsm0dchmc58mmhyagh3k";
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
