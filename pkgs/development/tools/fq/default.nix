{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testVersion
}:

buildGoModule rec {
  pname = "fq";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    sha256 = "sha256-mnb/9zcFSeBasGPYSGWoBhnldljGW3VK070zTO8M/uk=";
  };

  vendorSha256 = "sha256-KPIO/ZuiwxlnjGLaEuClkDsJnx/fwW0jPDBc7aTT68A=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
