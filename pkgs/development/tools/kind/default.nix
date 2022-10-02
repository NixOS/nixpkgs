{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

with lib;

buildGoModule rec {
  pname = "kind";
  version = "0.15.0";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "kubernetes-sigs";
    repo   = "kind";
    sha256 = "sha256-IDSWmNWHnTKOl6/N1Mz+OKOkZSBarpuN39CBsSjYhKY=";
  };

  patches = [
    # fix kernel module path used by kind
    ./kernel-module-path.patch
  ];

  vendorSha256 = "sha256-FE1GvNgXkBt2cH4YB3jTsPXp91DSiYlniQLtMwvi384=";

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
