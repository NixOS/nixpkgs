{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gotrue-supabase,
}:

buildGoModule rec {
  pname = "auth";
  version = "2.177.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "auth";
    rev = "v${version}";
    hash = "sha256-Ug0Kg6h4VrN1gXo7OmpLj5CLQcj/0tYQh5hGVIjXwhY=";
  };

  vendorHash = "sha256-AU14lvEQQx9JCb1awSo+h63QY0k2v7QibYP8kidfJ8A=";

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
