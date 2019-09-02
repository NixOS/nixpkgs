{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "skaffold-${version}";
  version = "0.21.1";
  # rev is the 0.21.1 commit, mainly for skaffold version command output
  rev = "a73671cb547a80d3437f78d046bc500269673ea3";

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
    sha256 = "0n4gqri4rmah1brckj9d4vidm6faabvwfy5smhpl3f6flyv3slsy";
  };

  meta = {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = https://github.com/GoogleContainerTools/skaffold;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}
