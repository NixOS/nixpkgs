{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pretender";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-iWAejgI/q1lh8daybPItzQA91Ayg3ZgddGFXWm3cuww=";
  };

  vendorHash = "sha256-uw3mpf27OH5uNKmvCFcTw+YFoxVEqT4Fz/CSl9Wjbv0=";

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
