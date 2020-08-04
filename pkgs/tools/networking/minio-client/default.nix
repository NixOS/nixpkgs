{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio-client";
  version = "2020-04-25T00-43-23Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "0ff2fyr3787zp0lpgbph064am33py2wzjikzmxd3zwp3y0dic770";
  };

  vendorSha256 = "0nfcxz47v5gl0wih59xarhz82nd8wy61c3ijvg2v08ipk29zivcc";

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
