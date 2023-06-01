{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, wander }:

buildGoModule rec {
  pname = "wander";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g9QAdwAqy3OA+nYsSpVLUPv1gn6N12339fgmYFT6Iys=";
  };

  vendorHash = "sha256-iTaZ5/0UrLJ3JE3FwQpvjKKrhqklG4n1WFTJhWfj/rI=";

  ldflags = [ "-s" "-w" "-X=github.com/robinovitch61/wander/cmd.Version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd wander \
      --fish <($out/bin/wander completion fish) \
      --bash <($out/bin/wander completion bash) \
      --zsh <($out/bin/wander completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = wander;
    command = "wander --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Terminal app/TUI for HashiCorp Nomad";
    license = licenses.mit;
    homepage = "https://github.com/robinovitch61/wander";
    maintainers = teams.c3d2.members;
  };
}
