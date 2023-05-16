{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "algolia-cli";
<<<<<<< HEAD
  version = "1.3.7";
=======
  version = "1.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "algolia";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Mg8GSomBP0jt+16S18tOq2f7HkVpCZbNz/A/g9Afk/I=";
  };

  vendorHash = "sha256-cNuBTH7L2K4TgD0H9FZ9CjhE5AGXADaniGLD9Lhrtrk=";
=======
    hash = "sha256-SNQhDmiRz0J3MlJbYUAQgiXeLv3oZVAMnavkAeRrnEA=";
  };

  vendorHash = "sha256-QgNL7pp0KH1RUV69BFVtHpaLHrPp4UQhEtOEiRmfAi0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
