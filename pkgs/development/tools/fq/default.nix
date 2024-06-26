{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fq,
  testers,
}:

buildGoModule rec {
  pname = "fq";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    hash = "sha256-C9YvAHzpNwOVbFWxmdT5BUwsLug7k6ZLYboYJTgp82I=";
  };

  vendorHash = "sha256-liNRrmcTbN9mLWvgcEFZbgBPAHFGCF/KMV6KwRBWgoU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    mainProgram = "fq";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
