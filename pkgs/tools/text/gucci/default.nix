{ lib, buildGoModule, fetchFromGitHub, testers, gucci }:

buildGoModule rec {
  pname = "gucci";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "noqcks";
    repo = "gucci";
    rev = "refs/tags/${version}";
    sha256 = "sha256-HJPNpLRJPnziSMvxLCiNDeCWO439ELSZs/4Cq1a7Amo=";
  };

  vendorSha256 = "sha256-rAZCj5xtwTgd9/KDYnQTU1jbabtWJF5MCFgcmixDN/Q=";

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
    platforms = platforms.unix;
  };
}
