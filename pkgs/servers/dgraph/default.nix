{ lib, buildGoModule, fetchFromGitHub, installShellFiles, jemalloc, nodejs }:

buildGoModule rec {
  pname = "dgraph";
  version = "22.0.1";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "sha256-c4gNkT1N1yPotDhRjZvuVvO5TTaL2bqR5I+Z2PcvW10=";
  };

  vendorSha256 = "sha256-K2Q2QBP6fJ3E2LEmZO2U/0DiQifrJVG0lcs4pO5yqrY=";

  doCheck = false;

  ldflags = [
    "-X github.com/dgraph-io/dgraph/x.dgraphVersion=${version}-oss"
  ];

  tags = [
    "oss"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # todo those dependencies are required in the makefile, but verify how they are used
  # actually
  buildInputs = [ jemalloc nodejs ];

  subPackages = [ "dgraph" ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/dgraph completion $shell > dgraph.$shell
      installShellCompletion dgraph.$shell
    done
  '';

  meta = with lib; {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    maintainers = with maintainers; [ sigma ];
    # Apache 2.0 because we use only build "oss"
    license = licenses.asl20;
  };
}
