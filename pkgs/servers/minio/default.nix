{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio";
  version = "2019-10-12T01-39-57Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "14rqwdhk2awdpcavkaqndf85c6aww5saarbfa2skc9z76ccq6114";
  };

  modSha256 = "1cnccmmqb63l78rnjwh9bivyfr79ixjg106fbgcrn3pwghfag7ma";

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
