{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio-client";
  version = "2019-12-17T23-26-28Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "1ck32p9k8fm1jnwb3zhq7h02s8wfzq46fhfgi8qmlmxfx02g1azw";
  };

  goPackagePath = "github.com/minio/mc";

  modSha256 = "0c3rx2wxszhhw68hnmvq7702bzrwris60gf450gmyyiyflq6a7ab";

  preBuild = ''
    buildFlagsArray+=("-ldflags=-X github.com/minio/mc/cmd.Version=${version}")
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/minio/mc";
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
