{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  mermerd,
}:

buildGoModule rec {
  pname = "mermerd";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "KarnerTh";
    repo = "mermerd";
    rev = "refs/tags/v${version}";
    hash = "sha256-7oBN9EeF3JBrOFuIM3lkNR2WMZA8PNDaKqdsVPawHBE=";
  };

  vendorHash = "sha256-bd/1LT0Pw25NhbnwQH3nmuCm3m8jBKPOYGRIRpcOGQI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  # the tests expect a database to be running
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion {
      package = mermerd;
      command = "mermerd version";
    };
  };

  meta = with lib; {
    description = "Create Mermaid-Js ERD diagrams from existing tables";
    mainProgram = "mermerd";
    homepage = "https://github.com/KarnerTh/mermerd";
    changelog = "https://github.com/KarnerTh/mermerd/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ austin-artificial ];
  };
}
