{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio";
  version = "2020-03-06T22-23-56Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "0h5zsdxm2b2by6lzqaa7jj0z773kjr89cl13gq9ddabml34f0kxh";
  };

  modSha256 = "0ikid628v673f7lvp3psk05s3liqlyc3arppg33lfi2cmbaf8hmr";

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
