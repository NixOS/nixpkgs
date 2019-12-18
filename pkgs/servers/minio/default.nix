{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio";
  version = "2019-12-17T23-16-33Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
    sha256 = "1mjlqmgxmlld09sq5j41rj479j5465xjzmx1pqw47lxanrzzb0lq";
  };

  modSha256 = "03icv54xr67c333xwky9g0wpq41pwbjzz6lyn0w2qaipi6xzm1pq";

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
