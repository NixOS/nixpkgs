{ buildGoModule
, doppler
, fetchFromGitHub
, installShellFiles
, lib
, testers
}:

buildGoModule rec {
  pname = "doppler";
<<<<<<< HEAD
  version = "3.65.2";
=======
  version = "3.58.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-rs+V19YaBvo5U9AAUks/nWl8TYveH8t+/rcQqjtG1gE=";
  };

  vendorHash = "sha256-FOmaK6S61fkzybpDx6qfi6m4e2IaqBpavaFhEgIvmqw=";
=======
    sha256 = "sha256-1cAsoaKKxSz2YhwMkfyzAyH8zFHm7YWS01/3CmcD8uY=";
  };

  vendorHash = "sha256-yuGjaUHfXCJnMvxfaSwbVAApflwfsvX2W7iEZdruMDE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s -w"
    "-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cli $out/bin/doppler
    installShellCompletion --cmd doppler \
      --bash <($out/bin/doppler completion bash) \
      --fish <($out/bin/doppler completion fish) \
      --zsh <($out/bin/doppler completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = doppler;
    version = "v${version}";
  };

  meta = with lib; {
    description = "The official CLI for interacting with your Doppler Enclave secrets and configuration";
    homepage = "https://doppler.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
