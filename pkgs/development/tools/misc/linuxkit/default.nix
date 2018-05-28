{ lib, buildGoPackage, go, fetchFromGitHub }:

buildGoPackage rec {
  name = "linuxkit-${version}";
  version = "2017-09-08";
  rev = "c793ea973cdfb98888d9d972d567cb988936263a";

  goPackagePath = "github.com/linuxkit/linuxkit";

  src = fetchFromGitHub {
    owner = "linuxkit";
    repo = "linuxkit";
    inherit rev;
    sha256 = "1bncj7hbwhmsl53qdh0zhkxrr4irchh92nh5i9ydisp23qzfkzh1";
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
