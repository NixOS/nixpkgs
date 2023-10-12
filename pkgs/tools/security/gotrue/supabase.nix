{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gotrue-supabase
}:

buildGoModule rec {
  pname = "gotrue";
  version = "2.99.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OUxiAEPX1mWL4td3xdiK9420i4K9pwNdGqch/5T21BY=";
  };

  vendorHash = "sha256-r1xJka1ISahaHJOkFwjn/Nrf2EU0iGVosz8PZnH31TE=";

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
