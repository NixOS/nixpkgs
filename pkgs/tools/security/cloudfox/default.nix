{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pUOraiYJsbQqOSYRMRzxcAcsBIz/2VBRnsKo1eHVSkQ=";
  };

  vendorHash = "sha256-nSisRurpareGI4EHENayMhsYOKL1hE1wVw2Ueiqii4U=";

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
