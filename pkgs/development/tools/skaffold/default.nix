{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "skaffold-${version}";
  version = "0.19.0";
  # rev is the 0.19.0 commit, mainly for skaffold version command output
  rev = "9eb0dfc1bf634b97462c66b4dfb80e4cea378ade";

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
    sha256 = "0s7dyfdmgslwnmbkzyqvf2622gj5d7vx9igwz3bf6dpaz382mk6h";
  };

  meta = {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = https://github.com/GoogleContainerTools/skaffold;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
  };
}
