{ lib, buildGoModule, fetchFromGitHub, installShellFiles, packr, ... }:

buildGoModule rec {
  pname = "kubernetes-polaris";
<<<<<<< HEAD
  version = "8.5.1";
=======
  version = "7.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "polaris";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-cfasYaZvUF5Ptc/BDVhafQ8wP6FA5msY+2IaeqmOvD8=";
  };

  vendorHash = "sha256-ZWetW+Xar4BXXlR0iG+O/NRqYk41x+PPVCGis2W2Nkk=";
=======
    sha256 = "sha256-PXyJpzmGTwSthaN0nVex8B7WpCxX7QxqRDoIJERSK6o=";
  };

  vendorHash = "sha256-SwHJRw75pP1zwi9ZMfUfcXt788pURM1KSbTNQF6XVqk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
  ];

  preBuild = ''
    ${packr}/bin/packr2 -v --ignore-imports
  '';

  postInstall = ''
    installShellCompletion --cmd polaris \
      --bash <($out/bin/polaris completion bash) \
      --fish <($out/bin/polaris completion fish) \
      --zsh <($out/bin/polaris completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/polaris help
    $out/bin/polaris version | grep 'Polaris version:${version}'

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Validate and remediate Kubernetes resources to ensure configuration best practices are followed";
    homepage = "https://www.fairwinds.com/polaris";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ longer ];
  };
}
