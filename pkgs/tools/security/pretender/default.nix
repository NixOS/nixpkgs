{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pretender";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-adWdUlsReRptSgRAjNH9bWy9dpwpuAWtVxlbDL2pMmk=";
  };

  vendorHash = "sha256-kDHRjd3Y90ocBGSJ0B2jAM9tO+iDSXoUOzLEWX2G0J4=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool for handling machine-in-the-middle tasks";
    homepage = "https://github.com/RedTeamPentesting/pretender";
    changelog = "https://github.com/RedTeamPentesting/pretender/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
