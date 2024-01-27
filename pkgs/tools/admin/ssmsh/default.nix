{ lib, buildGoModule, fetchFromGitHub, testers, ssmsh }:

buildGoModule rec {
  pname = "ssmsh";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "bwhaley";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GpN+yicgFIHOaMeJJcRn55f6fQbFX12vSV089/cMsqc=";
  };

  vendorHash = "sha256-17fmdsfOrOaySPsXofLzz0+vmiemg9MbnWhRoZ67EuQ=";

  doCheck = true;

  ldflags = [ "-w" "-s" "-X main.Version=${version}" ];

  passthru.tests = testers.testVersion {
    package = ssmsh;
    command = "ssmsh -version";
    version = "Version ${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/bwhaley/ssmsh";
    description = "An interactive shell for AWS Parameter Store";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
  };
}
