{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwt-hack";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K0ZtEi0zAKRlIGvorrXmtmkcMvyLIXWPnVMQANZbClk=";
  };

  vendorSha256 = "sha256-VYh3oRy8bmtXf6AnLNi/M2kA6t+crW3AXBiGovpdt8U=";

  meta = with lib; {
    description = "Tool for attacking JWT";
    homepage = "https://github.com/hahwul/jwt-hack";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
