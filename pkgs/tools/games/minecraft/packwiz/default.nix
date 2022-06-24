{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packwiz";
  version = "unstable-2022-06-08";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "d051932bbbeb7b16cd21a1897019428e71f63bfd";
    sha256 = "sha256-H1v5pY9hJYGP0ZiE/GrsATf1ljw69085t6PQhPOfYCs=";
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
