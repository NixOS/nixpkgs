{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gotrue-supabase,
}:

buildGoModule rec {
  pname = "auth";
  version = "2.173.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "auth";
    rev = "v${version}";
    hash = "sha256-9c7BFcI/eMUVwLhKdyIbM+DXrm9m3WdIaR87ps8aBro=";
  };

  vendorHash = "sha256-QBQUUFWT3H3L7ajFV8cgi0QREXnm0ReIisD+4ACfLZQ=";

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
