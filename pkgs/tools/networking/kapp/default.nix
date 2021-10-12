{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
buildGoModule rec {
  pname = "kapp";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
    sha256 = "sha256-9nvYxLE35IwmVB1Dzw7t3DZw4/kSiMPIqzl2PUKODtU=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kapp" ];

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
