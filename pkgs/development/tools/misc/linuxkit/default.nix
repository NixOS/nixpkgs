{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname   = "linuxkit";
  version = "1.0.0";

  goPackagePath = "github.com/linuxkit/linuxkit";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    rev = "v${version}";
    sha256 = "sha256-y/jsMr7HmrHjVMn4fyQ3MPHION8hQO2G4udX1AMx8bk=";
  };

  subPackages = [ "src/cmd/linuxkit" ];

  ldflags = [ "-s" "-w" "-X ${goPackagePath}/src/cmd/linuxkit/version.GitCommit=${src.rev}" "-X ${goPackagePath}/src/cmd/linuxkit/version.Version=${version}" ];

  meta = with lib; {
    description = "A toolkit for building secure, portable and lean operating systems for containers";
    license = licenses.asl20;
    homepage = "https://github.com/linuxkit/linuxkit";
    maintainers = [ maintainers.nicknovitski ];
    platforms = platforms.unix;
  };
}
