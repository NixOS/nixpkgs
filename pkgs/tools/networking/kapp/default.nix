{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
buildGoModule rec {
  pname = "kapp";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
    sha256 = "sha256-SxS6KBiKc68PcRycdVDWWfXBKOJvo7GuG/0dUQGcHsg=";
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
