{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "alterx";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "alterx";
    rev = "refs/tags/v${version}";
    hash = "sha256-F60nEkHmmhlRuHI2Hc3no2RvILhVN2oPXgwxpTdPDYM=";
  };

  vendorHash = "sha256-tIXSkNJbbT6X23WCUnB+c0FbxJdV3RF1iOrEJxETeaE=";

  meta = with lib; {
    description = "Fast and customizable subdomain wordlist generator using DSL";
    homepage = "https://github.com/projectdiscovery/alterx";
    changelog = "https://github.com/projectdiscovery/alterx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
