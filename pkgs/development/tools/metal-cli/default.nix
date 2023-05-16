{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "metal-cli";
<<<<<<< HEAD
  version = "0.16.0";
=======
  version = "0.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aZzz8KVvvhpdHAQ1QzSafc9Byu7bB9SobFjSad5RVPg=";
  };

  vendorHash = "sha256-1pVf5d05zuKmFHTdKnuDKbvKggVea0Z8vppj/hOw1rs=";
=======
    hash = "sha256-CibqkT4YHxQ7geUKROp7SMvamN0ba/FqTXFHO1TUP/k=";
  };

  vendorHash = "sha256-4hjrKlpd+gr/yLRuSq8XrOVl76uYVIMfYjTAgqkbOSw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/equinix/metal-cli/cmd.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd metal \
      --bash <($out/bin/metal completion bash) \
      --fish <($out/bin/metal completion fish) \
      --zsh <($out/bin/metal completion zsh)
  '';

  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
      $out/bin/metal --version | grep ${version}
  '';

  meta = with lib; {
    description = "Official Equinix Metal CLI";
    homepage = "https://github.com/equinix/metal-cli/";
    changelog = "https://github.com/equinix/metal-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne nshalman ];
    mainProgram = "metal";
  };
}
