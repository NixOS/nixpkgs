{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio-client";
  version = "2020-05-28T23-43-36Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "0amxws0pghks3b71qsm8qn5yi6njwyx89bl6mg6pxr1162cb756f";
  };

  vendorSha256 = "1w0s2773zs8pa818wz6wwyzw1m8qszgy96rdka2ni1x9s75l4znc";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/minio/mc/cmd.Version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/minio/mc";
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}