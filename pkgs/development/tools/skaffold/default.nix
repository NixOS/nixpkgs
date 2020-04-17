{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "skaffold";
  version = "1.6.0";
  # rev is the ${version} commit, mainly for skaffold version command output
  rev = "4cc0be23e41e37d8b1bca1464516538b2cc1bba0";

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
    sha256 = "0wz9x3p0hfajrkm1qrhl4kw7l7r3n6xv16chl4dxigaix8ga068h";
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
