{ lib, buildGoModule, fetchFromGitHub, installShellFiles, jemalloc, nodejs }:

buildGoModule rec {
  pname = "dgraph";
  version = "21.12.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "sha256-OYDWr+wJEIP7raIHsXSjvuFr2ENJOllufO5ff6lxoR4=";
  };

  vendorSha256 = "sha256-YtU3Yeq/lNeq7cOB+KvHbvlH9g40WuJk1ovHxCQMG60=";

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
    platforms = platforms.unix;
  };
}
