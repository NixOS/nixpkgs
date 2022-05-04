{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ent-go";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${version}";
    sha256 = "sha256-MvfbQKGVYWbZkqc3X3BqsB+z2KMkr0gMOquL02qHwUY=";
  };

  vendorSha256 = "sha256-BF2eD/jOtY1XhZ0hB7f3/frKQYwS9PbuGxum5SSnjzA=";

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
    downloadPage = "https://github.com/ent/ent";
    license = licenses.asl20;
    homepage = "https://entgo.io/";
    maintainers = with maintainers; [ superherointj ];
  };
}

