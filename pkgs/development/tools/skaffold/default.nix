{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "skaffold-${version}";
  version = "0.25.0";
  # rev is the 0.25.0 commit, mainly for skaffold version command output
  rev = "0f4b8fe88969e9fa38346934ea6af7c46772d603";

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
    sha256 = "0adcim029w64494sb3cw14xhv2vf33l8vhwm2wz8mnmr402nbvkx";
  };

  meta = {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = https://github.com/GoogleContainerTools/skaffold;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}
