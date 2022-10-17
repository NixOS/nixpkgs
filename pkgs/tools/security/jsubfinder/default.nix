{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jsubfinder";
  version = "unstable-2022-05-31";

  src = fetchFromGitHub {
    owner = "ThreatUnkown";
    repo = pname;
    rev = "e21de1ebc174bb69485f1c224e8063c77d87e4ad";
    hash = "sha256-QjRYJyk0uFGa6FCCYK9SIJhoyam4ALsQJ26DsmbNk8s=";
  };

  vendorSha256 = "sha256-pr4KkszyzEl+yLJousx29tr7UZDJf0arEfXBb7eumww=";

  meta = with lib; {
    description = "Tool to search for in Javascript hidden subdomains and secrets";
    homepage = "https://github.com/ThreatUnkown/jsubfinder";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
