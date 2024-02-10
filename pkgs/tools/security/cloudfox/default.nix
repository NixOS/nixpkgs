{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kklFn8HDMwsOjS0KDrWznGazE7RZtk0crxYEE3RuH8s=";
  };

  vendorHash = "sha256-qPIMmyKTmZEmxlLLftRMnBXvo22WFROYlCAAsAb7jDg=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = with lib; {
    description = "Tool for situational awareness of cloud penetration tests";
    homepage = "https://github.com/BishopFox/cloudfox";
    changelog = "https://github.com/BishopFox/cloudfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
