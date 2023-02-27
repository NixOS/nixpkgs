{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "algolia-cli";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "algolia";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-j0d2HK4McWA2yP7pt+TUOEYVUOQP4NYOdMlK7IqaAcU=";
  };

  vendorHash = "sha256-RG/aLlCve0XLj3ljBBSsloFUgNAG6faqjyMYXOo+CgI=";

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
