{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "cloudfox";
    rev = "refs/tags/v${version}";
    hash = "sha256-nN/gSvAwKjfZulqH4caGoJmzlY0ik8JrFReuvYWwZTE=";
  };

  vendorHash = "sha256-aRbGBEci3QT1mH+yaOUVynPysJ1za6CaoLGppJaa94c=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = with lib; {
    description = "Tool for situational awareness of cloud penetration tests";
    mainProgram = "cloudfox";
    homepage = "https://github.com/BishopFox/cloudfox";
    changelog = "https://github.com/BishopFox/cloudfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
