{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, wander }:

buildGoModule rec {
  pname = "wander";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BcjK1GNj6URk6PmZIqG/t6vvy5ZXo3Z6wDqY1kbLSfw=";
  };

  vendorSha256 = "sha256-iTaZ5/0UrLJ3JE3FwQpvjKKrhqklG4n1WFTJhWfj/rI=";

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
