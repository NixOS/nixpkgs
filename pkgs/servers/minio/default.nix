{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio";
  version = "2020-06-03T22-13-49Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "0rhnas8yc332q4k01npfwx9yk4hkckwyzpzkf1bxl2vcckn0bbv9";
  };

  vendorSha256 = "1f8vk0bip5gjhci26yy04lmnxxn0jm1hvyzzja6lqgfc02hz1rfx";

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