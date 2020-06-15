{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "skaffold";
  version = "1.11.0";
  # rev is the ${version} commit, mainly for skaffold version command output
  rev = "931a70a6334436735bfc4ff7633232dd5fc73cc1";

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
    sha256 = "035xp34m8kzb75mivgf3kw026n2h6g2a7j2mi32nxl1a794w36zi";
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash zsh; do
      $out/bin/skaffold completion $shell > skaffold.$shell
      installShellCompletion skaffold.$shell
    done
  '';

  meta = with lib; {
    description = "Easy and Repeatable Kubernetes Development";
    homepage = "https://skaffold.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester ];
  };
}
