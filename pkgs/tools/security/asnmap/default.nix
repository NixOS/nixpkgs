{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asnmap";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-J5Dn5eDzwj+ApwQ3ibTsMbwCobRAb1Cli+hbf74I9VQ=";
  };

  vendorHash = "sha256-0vU7YWZKiqi3WsjSTNvtUiskIczADgfRRC7rwCx8ho4=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to gather network ranges using ASN information";
    homepage = "https://github.com/projectdiscovery/asnmap";
    changelog = "https://github.com/projectdiscovery/asnmap/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
