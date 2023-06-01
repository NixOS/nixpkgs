{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ent-go";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${version}";
    sha256 = "sha256-EPUaBOvEAOjA24EYD0pyuNRdyX9qPxERXrBzHXC6cLI=";
  };

  vendorSha256 = "sha256-Q5vnfhUcbTmk3+t0D0z4dwU6pXKT7/hTfVHOUPXEzrg=";

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

