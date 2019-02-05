{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-${version}";
  version = "2019-01-31T00-31-19Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "0rvvjgnbk9khi443bahrg6iqa5lhmv8gydg96vgkrby13r1yy84k";
  };

  goPackagePath = "github.com/minio/minio";

  buildFlagsArray = [''-ldflags=
    -X github.com/minio/minio/cmd.Version=${version}
  ''];

  meta = with stdenv.lib; {
    homepage = https://www.minio.io/;
    description = "An S3-compatible object storage server";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
