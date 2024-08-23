{ lib, buildGo123Module, fetchFromGitHub }:

buildGo123Module rec {
  pname = "gotemplate";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sRCyOQmj4ti+1Qdap0Q5MLoJZLwjZtw1cYjZMGksvuA=";
  };

  vendorHash = "sha256-xtvexOmzTXjP3QsGp0aL3FdJe3mdBSCnTeM6hLq/tIo=";

  meta = with lib; {
    description = "CLI for go text/template";
    mainProgram = "gotemplate";
    changelog = "https://github.com/coveooss/gotemplate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
  };
}
