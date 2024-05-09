{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = "cloudfox";
    rev = "refs/tags/v${version}";
    hash = "sha256-vh7U66od+i1kmTtpHZ1tuMPTl0AnXoYUKMU16ZgxFBQ=";
  };

  vendorHash = "sha256-2+UiaU4S64afH8Y8uz5ZclO5NxTi4YlUZ87ZN1MnLj0=";

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
    mainProgram = "cloudfox";
  };
}
