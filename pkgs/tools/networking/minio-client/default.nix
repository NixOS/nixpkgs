{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minio-client";
  version = "2020-03-06T23-29-45Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "1vqvp7mn841s5g9vvas3c8j4y9lp90maw5y49hdv7zcsqncqvzkv";
  };

  modSha256 = "1qjfsqmcc6i0nixwvdmm3vnnv19yvqaaza096cpdf5rl35knsp5i";

  subPackages = [ "." ];

  preBuild = ''
    buildFlagsArray+=("-ldflags=-X github.com/minio/mc/cmd.Version=${version}")
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/minio/mc;
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ eelco bachp ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
