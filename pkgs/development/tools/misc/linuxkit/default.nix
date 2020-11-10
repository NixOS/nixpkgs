{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname   = "linuxkit";
  version = "0.8";

  goPackagePath = "github.com/linuxkit/linuxkit";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    rev = "v${version}";
    sha256 = "15jj60k8wz9cahjbdscnwyyfb1k1grjh7yrilb1cj4r8mby4sp2g";
  };

  subPackages = [ "src/cmd/linuxkit" ];

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/src/cmd/linuxkit/version.GitCommit=${src.rev} -X ${goPackagePath}/src/cmd/linuxkit/version.Version=${version}" ];

  meta = with lib; {
    description = "A toolkit for building secure, portable and lean operating systems for containers";
    license = licenses.asl20;
    homepage = "https://github.com/linuxkit/linuxkit";
    maintainers = [ maintainers.nicknovitski ];
    platforms = platforms.unix;
  };
}
