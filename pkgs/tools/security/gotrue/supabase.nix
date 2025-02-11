{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gotrue-supabase,
}:

buildGoModule rec {
  pname = "auth";
  version = "2.169.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "auth";
    rev = "v${version}";
    hash = "sha256-SPX4cdzz72Vd0d4fukxgZYQvESiXBzTKGEkDI5+tj04=";
  };

  vendorHash = "sha256-em1dBnNHsVPI7owd2gjERcJnrQbiVtZGtIqnFyker6M=";

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
