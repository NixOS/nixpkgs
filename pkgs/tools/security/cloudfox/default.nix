{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-V6zYEH2LACBcMY0ox8ZgqJGFLWFgCNR4l9Uo+hMgseE=";
  };

  vendorHash = "sha256-PZW1rNX8TLW0SZ9A2eF5N12J9BPWgRZJeGIb042Tinc=";

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
