{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ent-go";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${version}";
    sha256 = "sha256-ryOpaRQi30NPDNe9rUmW+fEqWSKWEsvHl/Bd1+i88y4=";
  };

  vendorHash = "sha256-67+4r4ByVS0LgfL7eUOdEoQ+CMRzqNjPgkq3dNfNwBY=";

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

