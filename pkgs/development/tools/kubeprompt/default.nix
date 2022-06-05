{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeprompt";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jlesquembre";
    repo = pname;
    rev = version;
    sha256 = "0ib61af6fwsl35gmid9jj0fp8zxgzrw4qk32r03hxzkh9g7r3kla";
  };

  ldflags = [
    "-w"
    "-s"
    "-X github.com/jlesquembre/kubeprompt/pkg/version.Version=${version}"
  ];

  vendorSha256 = "089lfkvyf00f05kkmr935jbrddf2c0v7m2356whqnz7ad6a2whsi";

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes prompt";
    homepage = "https://github.com/jlesquembre/kubeprompt";
    license = licenses.epl20;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
