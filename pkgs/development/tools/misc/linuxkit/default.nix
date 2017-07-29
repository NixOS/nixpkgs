{ lib, buildGoPackage, go, fetchFromGitHub }:

buildGoPackage rec {
  name = "linuxkit-${version}";
  version = "2017-07-08";
  rev = "8ca19a84d5281b1b15c7a48c21e5786943b47f1c";

  goPackagePath = "github.com/linuxkit/linuxkit";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    inherit rev;
    sha256 = "150y7hnjhi81iik7np27y5466ldaackq72mpi7vmybbl7vr1wgw4";
  };

  subPackages = [ "src/cmd/linuxkit" ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.GitCommit=${builtins.substring 0 7 rev} -X main.Version=0.0.0")
  '';

  meta = {
    description = "A toolkit for building secure, portable and lean operating systems for containers";
    license = lib.licenses.asl20;
    homepage = https://github.com/linuxkit/linuxkit;
    platforms = lib.platforms.unix;
  };
}
