{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tc946SAWBeKSNgLJZSkEoygxyXm3xbQm3cinIK1uOoY=";
  };

  vendorHash = "sha256-c2n8GlaD6q21gWUqr31UOioZRxO0s0tSpVRKl/YHXZU=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
