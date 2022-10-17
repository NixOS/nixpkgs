{ wander, buildGoModule, fetchFromGitHub, fetchpatch, installShellFiles, lib, testers }:

buildGoModule rec {
  pname = "wander";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G/TrfnmEyomdUCN5nUS9v5iqeUzgZzMLUZnfroQLZuk=";
  };

  vendorSha256 = "sha256-iTaZ5/0UrLJ3JE3FwQpvjKKrhqklG4n1WFTJhWfj/rI=";

  patches = [
    (fetchpatch {
      url = "https://github.com/robinovitch61/wander/commit/b3d3249541de005404a41c17a15218a4f73f68e5.patch";
      sha256 = "sha256-z8bdSFcAqnwEu0gupxW/L1o/asyxbvTYIdtLZNmQpz8=";
    })
  ];

  ldflags = [ "-X github.com/robinovitch61/wander/cmd.Version=v${version}" ];

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
