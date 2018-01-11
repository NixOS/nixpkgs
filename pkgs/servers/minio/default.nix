{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-${version}";

  version = "2018-01-02T23-07-00Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "1bpiy6q9782mxs5f5lzw6c7zx83s2i68rf5f65xa9z7cyl19si74";
  };

  goPackagePath = "github.com/minio/minio";

  buildFlagsArray = [''-ldflags=
    -X github.com/minio/minio/cmd.Version=${version}
  ''];

  meta = with stdenv.lib; {
    homepage = https://www.minio.io/;
    description = "An S3-compatible object storage server";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.x86_64 ++ ["aarch64-linux"];
    license = licenses.asl20;
  };
}
