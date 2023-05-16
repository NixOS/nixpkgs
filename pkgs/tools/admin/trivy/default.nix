{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, testers
, trivy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "trivy";
<<<<<<< HEAD
  version = "0.45.0";
=======
  version = "0.41.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-HsxcB3X8/n4Y8sU7im1nEGqMK9bVlhq5ZiF9gG+3YFs=";
  };

  # Hash mismatch on across Linux and Darwin
  proxyVendor = true;

  vendorHash = "sha256-rlMhmgnqvkKttfIzVMi1Ca/dqOdkoCF9yZbEcr8sv5I=";

  subPackages = [ "cmd/trivy" ];
=======
    rev = "v${version}";
    sha256 = "sha256-GDApctrRWRJ9svPBWGt86slnCtmZyciQ03rhYW1958s=";
  };
  # hash missmatch on across linux and darwin
  proxyVendor = true;
  vendorHash = "sha256-JlLQpBiviVXcX1xK0pi2igErCzvOXBc28m4fzDuIQ1U=";

  excludedPackages = [ "magefiles" "misc" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X=main.version=v${version}"
=======
    "-X main.version=v${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    package = trivy;
    command = "trivy --version";
    version = "v${version}";
  };
=======
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/trivy --help
    $out/bin/trivy --version | grep "v${version}"
    runHook postInstallCheck
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/aquasecurity/trivy";
    changelog = "https://github.com/aquasecurity/trivy/releases/tag/v${version}";
    description = "A simple and comprehensive vulnerability scanner for containers, suitable for CI";
    longDescription = ''
      Trivy is a simple and comprehensive vulnerability scanner for containers
      and other artifacts. A software vulnerability is a glitch, flaw, or
      weakness present in the software or in an Operating System. Trivy detects
      vulnerabilities of OS packages (Alpine, RHEL, CentOS, etc.) and
      application dependencies (Bundler, Composer, npm, yarn, etc.).
    '';
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ fab jk ];
=======
    maintainers = with maintainers; [ jk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
