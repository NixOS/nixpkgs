{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "skaffold-${version}";
  version = "0.35.0";
  # rev is the 0.35.0 commit, mainly for skaffold version command output
  rev = "1da7608f9eb21ebe722bc054584e591e4223a3dc";

  goPackagePath = "github.com/GoogleContainerTools/skaffold";
  subPackages = ["cmd/skaffold"];

  buildFlagsArray = let t = "${goPackagePath}/pkg/skaffold"; in  ''
    -ldflags=
      -X ${t}/version.version=v${version}
      -X ${t}/version.gitCommit=${rev}
      -X ${t}/version.buildDate=unknown
  '';

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "skaffold";
    rev = "v${version}";
    sha256 = "1vh7vlz14gfjpxf2wy1pybw5x55mw34j6isyy5zl0rsbs9mf6ci1";
  };

  meta = {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = https://github.com/GoogleContainerTools/skaffold;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}
