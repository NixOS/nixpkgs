{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, qovery-cli
, testers
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.46.4";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ROUMFpAgUmcKt7QG+Lfd3OipJQK8DLezvCxvev1yNlo=";
  };

  vendorSha256 = "sha256-4TY7/prMbvw5zVPJRoMLg7Omrxvh1HPGsdz1wqPn4uU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = qovery-cli;
    command = "HOME=$(mktemp -d); ${pname} version";
  };

  meta = with lib; {
    description = "Qovery Command Line Interface";
    homepage = "https://github.com/Qovery/qovery-cli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
