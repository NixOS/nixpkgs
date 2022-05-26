{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packwiz";
  version = "unstable-2022-5-25";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "e71b63ea98283c8c1f0e03ee51ae40f452f22a61";
    sha256 = "sha256-XwGacEVfQAduDCSMQFRw7Xnx4bND2zaV7l27B+2u5xg=";
  };

  vendorSha256 = "sha256-M9u7N4IrL0B4pPRQwQG5TlMaGT++w3ZKHZ0RdxEHPKk=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd packwiz \
      --bash <($out/bin/packwiz completion bash) \
      --fish <($out/bin/packwiz completion fish) \
      --zsh <($out/bin/packwiz completion zsh)
  '';

  meta = with lib; {
    description = "A command line tool for editing and distributing Minecraft modpacks, using a git-friendly TOML format";
    homepage = "https://packwiz.infra.link/";
    license = licenses.mit;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "packwiz";
  };
}
