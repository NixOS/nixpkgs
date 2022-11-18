{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ginkgo";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${version}";
    sha256 = "sha256-jZadmIefrK3kSStbG1Q3+R08/lEaBE/yWNSpPFSLW6I=";
  };
  vendorSha256 = "sha256-ZLDk61J7ci+OR1z3ddAfxeeDmRyTrVMHatc5thuCrl4=";

  # integration tests expect more file changes
  # types tests are missing CodeLocation
  excludedPackages = [ "integration" "types" ];

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
