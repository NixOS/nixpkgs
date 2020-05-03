{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio-client";
  version = "2020-04-04T05-28-55Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "09z28fq492d4l0089d1knq4zah9p2b212pkz777vznw9lzfqqip8";
  };

  modSha256 = "0cv824ar5ifsg93sylrfjmax6zqm5073y95hqqfcc1dfp0mv2ki3";

  subPackages = [ "." ];

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
