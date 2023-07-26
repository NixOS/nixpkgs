{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kind";
  version = "0.20.0";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "sha256-5yDoxrsnmz8N0Y35juItLtyclTz+pSb75B1P716XPxU=";
  };

  patches = [
    # fix kernel module path used by kind
    ./kernel-module-path.patch
  ];

  vendorHash = "sha256-J/sJd2LLMBr53Z3sGrWgnWA8Ry+XqqfCEObqFyUD96g=";

  CGO_ENABLED = 0;
  GOFLAGS = [ "-trimpath" ];
  ldFlags = [ "-buildid=" "-w" ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kind completion $shell > kind.$shell
      installShellCompletion kind.$shell
    done
  '';

  meta = with lib; {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [ offline rawkode ];
    license     = licenses.asl20;
  };
}
