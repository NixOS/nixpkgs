{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, testers
, adrgen
, installShellFiles
}:

buildGoModule rec {
  pname = "adrgen";
  version = "0.4.1-beta";

  src = fetchFromGitHub {
    owner = "asiermarques";
    repo = "adrgen";
    rev = "v${version}";
    hash = "sha256-9EiJe5shhwbjLIvUQMUTSGTgCA+r3RdkLkPRPoWvZ3g=";
  };

  nativeBuildInputs = [ installShellFiles ];


  vendorHash = "sha256-RXwwv3Q/kQ6FondpiUm5XZogAVK2aaVmKu4hfr+AnAM=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = adrgen;
    command = "adrgen version";
    version = "v${version}";
  };

  postInstall = ''
    installShellCompletion --cmd adrgen \
      --bash <($out/bin/adrgen completion bash) \
      --fish <($out/bin/adrgen completion fish) \
      --zsh <($out/bin/adrgen completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/asiermarques/adrgen";
    description = "Command-line tool for generating and managing Architecture Decision Records";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "adrgen";
  };
}
