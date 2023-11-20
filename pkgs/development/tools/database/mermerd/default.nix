{ lib
, buildGoModule
, fetchFromGitHub
, testers
, mermerd
}:

buildGoModule rec {
  pname = "mermerd";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "KarnerTh";
    repo = "mermerd";
    rev = "refs/tags/v${version}";
    hash = "sha256-oYX1473bfZHwCscIpZSDfkKgIsGMcmkFGfWI400Maao=";
  };

  vendorHash = "sha256-RSCpkQymvUvY2bOkjhsyKnDa3vezUjC33Nwv0+O4OOQ=";

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
    homepage = "https://github.com/KarnerTh/mermerd";
    changelog = "https://github.com/KarnerTh/mermerd/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ austin-artificial ];
  };
}
