{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ent-go";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${version}";
    sha256 = "sha256-OEQWNWGVs0QYhPuCGEFgAVaUnfswmvWVt+e0cAdkBKE=";
  };

  vendorHash = "sha256-9KdSGIyi95EVQq9jGoVqK8aq3JXlQXB+Qwlh/Kfz4Oc=";

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

  meta = {
    description = "Entity framework for Go";
    homepage = "https://entgo.io/";
    changelog = "https://github.com/ent/ent/releases/tag/v${version}";
    downloadPage = "https://github.com/ent/ent";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "ent";
  };
}
