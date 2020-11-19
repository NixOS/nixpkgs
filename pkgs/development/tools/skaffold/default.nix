{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "skaffold";
  version = "1.16.0";

  goPackagePath = "github.com/GoogleContainerTools/skaffold";
  subPackages = ["cmd/skaffold"];

  buildFlagsArray = let t = "${goPackagePath}/pkg/skaffold"; in  ''
    -ldflags=
      -s -w
      -X ${t}/version.version=v${version}
      -X ${t}/version.gitCommit=${src.rev}
      -X ${t}/version.buildDate=unknown
  '';

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = "skaffold";
    rev = "v${version}";
    sha256 = "18v1s1k05bq38aljazvpxvp543xchy9h4n531pis4w4jl47n387f";
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
