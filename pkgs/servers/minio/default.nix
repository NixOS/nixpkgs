{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio";
  version = "2020-03-25T07-03-04Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "0xdflc7pfx1misbh695x8kmqpysi5iydsarr9mwmjragf5b1kbl5";
  };

  modSha256 = "09kbibsfa7qq55paqr7wcs4gpwk6g5pknc5fjssmd12nm2cji96k";

  subPackages = [ "." ];

  buildFlagsArray = [''-ldflags=
    -X github.com/minio/minio/cmd.Version=${version}
  ''];

  meta = with stdenv.lib; {
    homepage = "https://www.minio.io/";
    description = "An S3-compatible object storage server";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
