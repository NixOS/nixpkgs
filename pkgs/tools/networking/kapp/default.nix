{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
buildGoModule rec {
  pname = "kapp";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
    sha256 = "sha256-sCQD0hZTJaeueBTu4XPiPVC5dhPWkTQn0mKwWVT5H/0=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kapp" ];

  ldflags = [
    "-X github.com/k14s/kapp/pkg/kapp/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kapp completion $shell > kapp.$shell
      installShellCompletion kapp.$shell
    done
  '';

  meta = with lib; {
    description = "CLI tool that encourages Kubernetes users to manage bulk resources with an application abstraction for grouping";
    homepage = "https://get-kapp.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
  };
}
