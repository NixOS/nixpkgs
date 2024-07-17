{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "containerlab";
  version = "0.54.2";

  src = fetchFromGitHub {
    owner = "srl-labs";
    repo = "containerlab";
    rev = "v${version}";
    hash = "sha256-XRFSfMe08w69oudCDGfnJxROA7ycZEMNbAWP6zJKTN0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-+buFaaUb4wCrlIBG+SwPXp/PqU/qvdfHTpEH4OrXsUs=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/srl-labs/containerlab/cmd.version=${version}"
    "-X"
    "github.com/srl-labs/containerlab/cmd.commit=${src.rev}"
    "-X"
    "github.com/srl-labs/containerlab/cmd.date=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    local INSTALL="$out/bin/containerlab"
    installShellCompletion --cmd containerlab \
      --bash <($out/bin/containerlab completion bash) \
      --fish <($out/bin/containerlab completion fish) \
      --zsh <($out/bin/containerlab completion zsh)
  '';

  meta = with lib; {
    description = "Container-based networking lab";
    homepage = "https://containerlab.dev/";
    changelog = "https://github.com/srl-labs/containerlab/releases/tag/${src.rev}";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "containerlab";
  };
}
