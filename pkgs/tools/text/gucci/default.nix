{ lib, buildGoModule, fetchFromGitHub, testers, gucci }:

buildGoModule rec {
  pname = "gucci";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "noqcks";
    repo = "gucci";
    rev = "refs/tags/${version}";
    sha256 = "sha256-0ZVRjzU/KTqhaQC6zubbcNp1jX2pgFSGyyIYcWaHzeU=";
  };

  vendorHash = "sha256-/4OnbtxxhXQnmSV6UbjgzXdL7szhL9rKiG5BR8FsyqI=";

  ldflags = [ "-s" "-w" "-X main.AppVersion=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = gucci;
  };

  checkFlags = [ "-short" ];

  # Integration tests rely on Ginkgo but fail.
  # Related: https://github.com/onsi/ginkgo/issues/602
  #
  # Disable integration tests.
  preCheck = ''
    buildFlagsArray+=("-run" "[^(TestIntegration)]")
  '';

  meta = with lib; {
    description = "A simple CLI templating tool written in golang";
    homepage = "https://github.com/noqcks/gucci";
    license = licenses.mit;
    maintainers = with maintainers; [ braydenjw ];
  };
}
