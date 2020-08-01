{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio";
  version = "2020-05-01T22-19-14Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "0yyq5j82rcl8yhn2jg8sjfxii6kzbrbmxvb05yiwv7p0q42ag5rn";
  };

  vendorSha256 = "15yx5nkyf424v42glg3cx0gkqckdfv1xn25570s9cwf8zid0zlxd";

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
