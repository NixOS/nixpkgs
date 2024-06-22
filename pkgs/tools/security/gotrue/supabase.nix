{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gotrue-supabase
}:

buildGoModule rec {
  pname = "gotrue";
  version = "2.154.1";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z2v/o89lU2OvlRAk3EHLRAFx/wg+1ZRAjLns8Oj7tBk=";
  };

  vendorHash = "sha256-iq+QNJ2TT4setmMy7s4lUdNAUraneeINfB0CVKax4Yg=";

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
    description = "JWT based API for managing users and issuing JWT tokens";
    mainProgram = "gotrue";
    changelog = "https://github.com/supabase/gotrue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
