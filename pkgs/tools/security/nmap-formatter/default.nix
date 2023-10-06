{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i2g+l5XJkBjXMbJwpSirEKCDxO2Ric4CwF3jzue/4+o=";
  };

  vendorHash = "sha256-YAsWXbIyeC4uhzRFXX/bZs3cOvEa3k4/ZCoDisUN1Yw=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
