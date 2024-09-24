{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gotrue-supabase
}:

buildGoModule rec {
  pname = "auth";
  version = "2.161.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "auth";
    rev = "v${version}";
    hash = "sha256-+tWCA1FGmvqivYI/wqaVY0zJKwqUqpZfotuHhHmuDwc=";
  };

  vendorHash = "sha256-nmvZKkSfOflsrcos3cCZHrq4DVF23TQG9kST0AcjN7E=";

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
