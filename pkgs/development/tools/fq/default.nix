{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testers
}:

buildGoModule rec {
  pname = "fq";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    sha256 = "sha256-tKJ07CNyiL2z/FYd8K3Iurif2hmdHKcNClV3odR2c64=";
  };

  vendorSha256 = "sha256-v4bpShw78hJE4KupE1VhbbUYmQftwpRmQ67Nuw+HAZU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
