{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gotrue-supabase
}:

buildGoModule rec {
  pname = "gotrue";
  version = "2.105.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6tFXuVBd7UptoVMSse1Pk9ok6XyGL994pfFkFTyc5I0=";
  };

  vendorHash = "sha256-cwTwze8WuhL5exaY5HJYDgcxNB9O1QuFpJgZmj6R838=";

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
