{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gotrue-supabase
}:

buildGoModule rec {
  pname = "gotrue";
  version = "2.47.1";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GBrdYlWvtlz/A/5Tn58EPYBL3X73D44GzbN1OrzwU8U=";
  };

  vendorHash = "sha256-FIl30sKmdcXayK8KWGFl+N+lYExl4ibKZ2tcvelw8zo=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/netlify/gotrue/internal/utilities.Version=${version}"
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
