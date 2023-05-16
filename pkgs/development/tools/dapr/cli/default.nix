{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "dapr-cli";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dapr";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Fhuksf0EMzu3JBLO4eZyc8GctNyfNE1v/8a3TOFKKQg=";
  };

  vendorHash = "sha256-DpHb+TCBW0fkwRZRqeGABo5psLJNBOW1nSSRWWVn+Mg=";
=======
    sha256 = "sha256-LBsJjAtsKlecRhes9q+HYCwlhZn0jUhhEzu62nATGz8=";
  };

  vendorSha256 = "sha256-t2uew44kLLDM6cuWUV5Joa+h88BhRv3GnnckDshB5Tw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  ldflags = [
    "-X main.version=${version}"
    "-X main.apiVersion=1.0"
    "-X github.com/dapr/cli/pkg/standalone.gitcommit=${src.rev}"
    "-X github.com/dapr/cli/pkg/standalone.gitversion=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr

    installShellCompletion --cmd dapr \
      --bash <($out/bin/dapr completion bash) \
      --zsh <($out/bin/dapr completion zsh)
  '';

  meta = with lib; {
    description = "A CLI for managing Dapr, the distributed application runtime";
    homepage = "https://dapr.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ joshvanl lucperkins ];
    mainProgram = "dapr";
  };
}
