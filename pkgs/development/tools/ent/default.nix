{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ent-go";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${version}";
    sha256 = "sha256-g4n9cOTv/35WkvMjrtP2eEcbiu5kiafVXifz1zlEuCY=";
  };

  vendorHash = "sha256-DUi4Ik+qFbx4LIm9MDJ4H9/+sIfCzK8MMGKp0GIGX7w=";

  subPackages = [ "cmd/ent" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd ent \
      --bash <($out/bin/ent completion bash) \
      --fish <($out/bin/ent completion fish) \
      --zsh <($out/bin/ent completion zsh)
  '';

  meta = with lib; {
    description = "An entity framework for Go";
    homepage = "https://entgo.io/";
    downloadPage = "https://github.com/ent/ent";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "ent";
  };
}

