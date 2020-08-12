{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio";
  version = "2020-08-08T04-50-06Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "0l5yd3k154h3q9sc5psv80n9wpnhpj5sb3r9v9gsqcam46ljwpna";
  };

  vendorSha256 = "1xxhvgawkj2lq39cxgl4l5v41m6nsask79n2cxfpcgb00fqq147x";

  doCheck = false;

  subPackages = [ "." ];

  buildFlagsArray = [''-ldflags=
    -s -w -X github.com/minio/minio/cmd.Version=${version}
  ''];

  passthru.tests.minio = nixosTests.minio;

  meta = with stdenv.lib; {
    homepage = "https://www.minio.io/";
    description = "An S3-compatible object storage server";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
