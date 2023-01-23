{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

with lib;

buildGoModule rec {
  pname = "kind";
  version = "0.17.0";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "sha256-YAa5Dr8Pc6P3RZ3SCiyi7zwmVd5tPalM88R8bxgg6JU=";
  };

  patches = [
    # fix kernel module path used by kind
    ./kernel-module-path.patch
  ];

  vendorSha256 = "sha256-J/sJd2LLMBr53Z3sGrWgnWA8Ry+XqqfCEObqFyUD96g=";

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

  meta = {
    description = "Kubernetes IN Docker - local clusters for testing Kubernetes";
    homepage    = "https://github.com/kubernetes-sigs/kind";
    maintainers = with maintainers; [ offline rawkode ];
    license     = lib.licenses.asl20;
    platforms   = platforms.unix;
  };
}
