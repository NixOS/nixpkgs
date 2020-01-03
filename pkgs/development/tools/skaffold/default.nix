{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "skaffold";
  version = "1.0.1";
  # rev is the 1.0.1 commit, mainly for skaffold version command output
  rev = "934dd5ad304bef89cb3619b5b2ef53eb8cf04715";

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
    sha256 = "0pvidf8m6v56qa3dlqls55jcmjqb54spkx7xxynvhj3590pjw4qx";
  };

  meta = {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = https://github.com/GoogleContainerTools/skaffold;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}
