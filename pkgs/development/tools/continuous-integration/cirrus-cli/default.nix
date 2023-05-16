{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "cirrus-cli";
<<<<<<< HEAD
  version = "0.102.0";
=======
  version = "0.97.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-JF93tVEwGY4wHNNkQyzxjai6S+qLzBd0SPdDgkn4Wdc=";
  };

  vendorHash = "sha256-ryEFSFQFASH+yzmHbxLSywg9xewbvg9JGliSJrFC4U0=";
=======
    sha256 = "sha256-6MkQUnqHn96S4+hGuHHfJojZUJXNxWTkmLkahVZWQTA=";
  };

  vendorHash = "sha256-gqpcGEbvfVMkAQ3c6EwW9xTTeMH9VOlMiuCz7uZUbnw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd cirrus \
      --bash <($out/bin/cirrus completion bash) \
      --zsh <($out/bin/cirrus completion zsh) \
      --fish <($out/bin/cirrus completion fish)
  '';

  # tests fail on read-only filesystem
  doCheck = false;

  meta = with lib; {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
<<<<<<< HEAD
    license = licenses.agpl3Plus;
=======
    license = licenses.agpl3Only;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "cirrus";
  };
}
