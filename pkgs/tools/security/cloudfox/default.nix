{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-46w0/Da5sJkw2jLEGiFICEaX9bvCs0sbad1RyDCxINw=";
  };

  vendorHash = "sha256-lgccNq1cSg8rrHW0aMLcC5HrZXf8TvdFSmk6pbGXNqQ=";

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
