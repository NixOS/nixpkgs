{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio";
  version = "2020-05-01T22-19-14Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "0yyq5j82rcl8yhn2jg8sjfxii6kzbrbmxvb05yiwv7p0q42ag5rn";
  };

  modSha256 = "1g5vwllxpiy4qlfhn3v5k6sn4g4qpbv0hpg32y1vi2q342lag116";

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
