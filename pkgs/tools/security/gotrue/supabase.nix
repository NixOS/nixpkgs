{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotrue";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZLonPW7lXaBE039R21DWjRBa7xxRnH9rTNu4PDNOWoY=";
  };

  vendorHash = "sha256-3dXfg9tblPx9V5LzzVm3UtCwGcPIAm2MaKm9JQi69mU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/netlify/gotrue/utilities.Version=${version}"
  ];

  # integration tests require network to connect to postgres database
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase/gotrue";
    description = "A JWT based API for managing users and issuing JWT tokens";
    changelog = "https://github.com/supabase/gotrue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
