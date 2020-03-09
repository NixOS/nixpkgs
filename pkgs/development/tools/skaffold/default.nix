{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "skaffold";
  version = "1.4.0";
  # rev is the ${version} commit, mainly for skaffold version command output
  rev = "bb324609b4254ceb9f76d35eb03642a6a1807867";

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
    sha256 = "0nrz2gnp722cq4p8lcfl0nlws53c2bfq17jgr2jad4vyjglgfscw";
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash zsh; do
      $bin/bin/skaffold completion $shell > skaffold.$shell
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
