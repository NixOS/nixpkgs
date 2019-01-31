{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "minio-${version}";
  version = "2019-01-23T23-18-58Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "07clcsxm4xgp7df5y6zkkgflp2f5mnzrl8fkzr6b08ij3cpmi2ws";
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
