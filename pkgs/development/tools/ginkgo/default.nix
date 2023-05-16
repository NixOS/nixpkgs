{ lib, buildGoModule, fetchFromGitHub, testers, ginkgo }:

buildGoModule rec {
  pname = "ginkgo";
<<<<<<< HEAD
  version = "2.12.0";
=======
  version = "2.9.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ikZ3vuoGYCbjvcpqol11WZ1PfxqSm1VNfdLDJIlNeP0=";
  };
  vendorHash = "sha256-huXVFvSd2KkNqb6BWsTY2megnD9dJLy7edX2mGBv0rU=";
=======
    sha256 = "sha256-groih0LxtmB8k4/vfw2Ivtzm+SOyQqK1o7XASNplFvQ=";
  };
  vendorHash = "sha256-Rm5fpiTZMo/B9+yIpmEniJVRfKgHjpFIagELEjgFYwc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # integration tests expect more file changes
  # types tests are missing CodeLocation
  excludedPackages = [ "integration" "types" ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = ginkgo;
    command = "ginkgo version";
  };

  meta = with lib; {
    homepage = "https://onsi.github.io/ginkgo/";
    changelog = "https://github.com/onsi/ginkgo/blob/master/CHANGELOG.md";
    description = "A Modern Testing Framework for Go";
    longDescription = ''
      Ginkgo is a testing framework for Go designed to help you write expressive
      tests. It is best paired with the Gomega matcher library. When combined,
      Ginkgo and Gomega provide a rich and expressive DSL
      (Domain-specific Language) for writing tests.

      Ginkgo is sometimes described as a "Behavior Driven Development" (BDD)
      framework. In reality, Ginkgo is a general purpose testing framework in
      active use across a wide variety of testing contexts: unit tests,
      integration tests, acceptance test, performance tests, etc.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ saschagrunert jk ];
  };
}
