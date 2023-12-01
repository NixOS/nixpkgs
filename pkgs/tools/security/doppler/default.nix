{ buildGoModule
, doppler
, fetchFromGitHub
, installShellFiles
, lib
, testers
}:

buildGoModule rec {
  pname = "doppler";
  version = "3.66.3";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "sha256-zS5nIULnzoOG43nNcVb6MdmKNDcDK75mh3SOMB5BXIY=";
  };

  vendorHash = "sha256-FOmaK6S61fkzybpDx6qfi6m4e2IaqBpavaFhEgIvmqw=";

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
