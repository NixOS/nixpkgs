{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "skaffold";
  version = "0.34.1";
  # rev is the 0.34.1 commit, mainly for skaffold version command output
  rev = "a1efe8cc46e7584ad71c2f140cbfb94c1b4d82ff";

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
    sha256 = "1qcl0nn8rh3a23y3rg8zarzkq5m0gxrrgy5jbspwzs63rgapifiy";
  };

  meta = {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = https://github.com/GoogleContainerTools/skaffold;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}
