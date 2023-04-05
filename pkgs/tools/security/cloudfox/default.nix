{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7xU99BqohfvUT23uW1l5thm20ZgeAPteR9xThuLR1AI=";
  };

  vendorHash = "sha256-v8rEsp2mDgfjCO2VvWNIxex8F350MDnZ40bR4szv+3o=";

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
