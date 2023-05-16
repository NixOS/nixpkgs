{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "golangci-lint";
<<<<<<< HEAD
  version = "1.54.2";
=======
  version = "1.52.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7nbgiUrp7S7sXt7uFXX8NHYbIRLZZQcg+18IdwAZBfE=";
  };

  vendorHash = "sha256-IyH5lG2a4zjsg/MUonCUiAgMl4xx8zSflRyzNgk8MR0=";
=======
    hash = "sha256-FmNXjOMDDdGxMQvy5f1NoaqrKFpmlPWclXooMxXP8zg=";
  };

  vendorHash = "sha256-BhD3a0LNc3hpiH4QC8FpmNn3swx3to8+6gfcgZT8TLg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
    "-X main.date=19700101-00:00:00"
  ];

  postInstall = ''
    for shell in bash zsh fish; do
      HOME=$TMPDIR $out/bin/golangci-lint completion $shell > golangci-lint.$shell
      installShellCompletion golangci-lint.$shell
    done
  '';

  meta = with lib; {
    description = "Fast linters Runner for Go";
    homepage = "https://golangci-lint.run/";
<<<<<<< HEAD
    changelog = "https://github.com/golangci/golangci-lint/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ anpryl manveru mic92 ];
  };
}
