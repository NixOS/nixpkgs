{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.20";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t7lcUbD3840kClFr4+RYRD4d2yGeYhnr2HO5giYLhNU=";
  };

  vendorHash = "sha256-6NHaOF+fXs49JXEog/t2Fmr8llLmMBj7/OISssyzRK4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd ctlptl \
      --bash <($out/bin/ctlptl completion bash) \
      --fish <($out/bin/ctlptl completion fish) \
      --zsh <($out/bin/ctlptl completion zsh)
  '';

  meta = with lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
