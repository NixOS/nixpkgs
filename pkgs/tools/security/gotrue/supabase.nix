{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gotrue-supabase
}:

buildGoModule rec {
  pname = "auth";
  version = "2.165.1";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "auth";
    rev = "v${version}";
    hash = "sha256-Tp8h20GM2YULlElFtHS41rFyWSIT3EGGXKtExkuO5P8=";
  };

  vendorHash = "sha256-w6qbqHHdXdDYHO5Asa0fkf0UBI7Wr2Voc2K4Ss1zDCE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/supabase/auth/internal/utilities.Version=${version}"
  ];

  # integration tests require network to connect to postgres database
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = gotrue-supabase;
    command = "auth version";
    inherit version;
  };

  meta = with lib; {
    homepage = "https://github.com/supabase/auth";
    description = "JWT based API for managing users and issuing JWT tokens";
    mainProgram = "auth";
    changelog = "https://github.com/supabase/auth/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
