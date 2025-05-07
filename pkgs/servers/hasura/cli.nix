{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hasura";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "hasura";
    repo = "graphql-engine";
    rev = "v${version}";
    sha256 = "1r19qw2wxzmngb6sjpin3dk6i5r491brcb0ir4g8kw9d0ic90hpy";
  };
  modRoot = "./cli";

  subPackages = [ "cmd/hasura" ];

  vendorHash = "sha256-S6xyevC/7dpn2Ana5mkROwIOvtQVPThoNEVKkXQmUGY=";

  doCheck = false;

  ldflags = [
    "-X github.com/hasura/graphql-engine/cli/version.BuildVersion=${version}"
    "-s"
    "-w"
  ];

  postInstall = ''
    mkdir -p $out/share/{bash-completion/completions,zsh/site-functions}

    export HOME=$PWD
    $out/bin/hasura completion bash > $out/share/bash-completion/completions/hasura
    $out/bin/hasura completion zsh > $out/share/zsh/site-functions/_hasura
  '';

  meta = {
    homepage = "https://www.hasura.io";
    maintainers = [ lib.maintainers.lassulus ];
    license = lib.licenses.asl20;
    description = "Hasura GraphQL Engine CLI";
    mainProgram = "hasura";
  };
}
