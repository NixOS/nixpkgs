{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packwiz";
  version = "unstable-2023-02-13";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "4b336e46e277d4b252c11f43080576dc23b001d2";
    sha256 = "sha256-f6560XrnriKNq89aOxfJjN4mDdtYzMSOUlRWwItLuHk=";
  };

  vendorSha256 = "sha256-yL5pWbVqf6mEpgYsItLnv8nwSmoMP+SE0rX/s7u2vCg=";

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
