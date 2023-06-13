{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gotrue-supabase
}:

buildGoModule rec {
  pname = "gotrue";
  version = "2.70.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1xOHf5hu0h+Ak4zALmsu1AoQMzeyWVE0l6JH77sZnfo=";
  };

  vendorHash = "sha256-ZWY+l8qrtYNul2xAtg9fSmMIS7Z1TlKDTKotwf/fN/4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/supabase/gotrue/internal/utilities.Version=${version}"
  ];

  # integration tests require network to connect to postgres database
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = gotrue-supabase;
    command = "gotrue version";
    inherit version;
  };

  meta = with lib; {
    homepage = "https://github.com/supabase/gotrue";
    description = "A JWT based API for managing users and issuing JWT tokens";
    changelog = "https://github.com/supabase/gotrue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
