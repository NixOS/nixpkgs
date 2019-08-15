{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "minio";
  version = "2019-02-26T19-51-46Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "1f2c7wzcb47msb0iqrcc0idz39wdm9fz61q835ks1nx4qs6hi2db";
  };

  goPackagePath = "github.com/minio/minio";

  subPackages = [ "." ];

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
