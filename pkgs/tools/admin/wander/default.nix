{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "wander";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ULttOJcP3LHQAlyJKGEKT3B3PqYOP5+IxDej673020M=";
  };

  vendorHash = "sha256-0S8tzP5yNUrH6fp+v7nbUPTMWzYXyGw+ZNcXkSN+tWY=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd wander \
      --fish <($out/bin/wander completion fish) \
      --bash <($out/bin/wander completion bash) \
      --zsh <($out/bin/wander completion zsh)
  '';

  meta = with lib; {
    description = "Terminal app/TUI for HashiCorp Nomad";
    license = licenses.mit;
    homepage = "https://github.com/robinovitch61/wander";
    maintainers = teams.c3d2.members;
  };
}
