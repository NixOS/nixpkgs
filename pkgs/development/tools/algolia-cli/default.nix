{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "algolia-cli";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "algolia";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-OclNhqJ7BJwpwu8EWjZuIw/an4K7dETjynrU0Ju1yak=";
  };

  vendorHash = "sha256-QgNL7pp0KH1RUV69BFVtHpaLHrPp4UQhEtOEiRmfAi0=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/algolia" ];

  ldflags = [ "-s" "-w" "-X github.com/algolia/cli/pkg/version.Version=${version}" ];

  postInstall = ''
    installShellCompletion --cmd algolia \
      --bash <($out/bin/algolia completion bash) \
      --fish <($out/bin/algolia completion fish) \
      --zsh <($out/bin/algolia completion zsh)
  '';

  meta = with lib; {
    description = "Algolia’s official CLI devtool";
    homepage = "https://algolia.com/doc/tools/cli/";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
