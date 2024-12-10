{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "qc";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "qownnotes";
    repo = "qc";
    rev = "v${version}";
    hash = "sha256-SrvcRF2yRGGPTk835ykG+NH9WPoc/bXO5tSj43Q7T3g=";
  };

  vendorHash = "sha256-7t5rQliLm6pMUHhtev/kNrQ7AOvmA/rR93SwNQhov6o=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/qownnotes/qc/cmd.version=${version}"
  ];

  # There are no automated tests
  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    export HOME=$(mktemp -d)
    installShellCompletion --cmd qc \
      --bash <($out/bin/qc completion bash) \
      --fish <($out/bin/qc completion fish) \
      --zsh <($out/bin/qc completion zsh)
  '';

  meta = with lib; {
    description = "QOwnNotes command-line snippet manager";
    mainProgram = "qc";
    homepage = "https://github.com/qownnotes/qc";
    license = licenses.mit;
    maintainers = with maintainers; [
      pbek
      totoroot
    ];
  };
}
