{ lib, buildGoModule, fetchFromGitHub, testers, gucci }:

buildGoModule rec {
  pname = "gucci";
  version = "1.6.10";

  src = fetchFromGitHub {
    owner = "noqcks";
    repo = "gucci";
    rev = "refs/tags/${version}";
    sha256 = "sha256-bwPQQtaPHby96C5ZHZhBTok+m8GPPS40U1CUPVYqCa4=";
  };

  vendorHash = "sha256-/4OnbtxxhXQnmSV6UbjgzXdL7szhL9rKiG5BR8FsyqI=";

  ldflags = [ "-s" "-w" "-X main.AppVersion=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = gucci;
  };

  checkFlags = [
    "-short"
    # Integration tests rely on Ginkgo but fail.
    # Related: https://github.com/onsi/ginkgo/issues/602
    #
    # Disable integration tests.
    "-skip=^TestIntegration"
  ];

  meta = with lib; {
    description = "A simple CLI templating tool written in golang";
    mainProgram = "gucci";
    homepage = "https://github.com/noqcks/gucci";
    license = licenses.mit;
    maintainers = with maintainers; [ braydenjw ];
  };
}
