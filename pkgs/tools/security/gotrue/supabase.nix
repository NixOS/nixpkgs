{ lib
, buildGoModule
, fetchFromGitHub
, testers
, gotrue-supabase
}:

buildGoModule rec {
  pname = "gotrue";
<<<<<<< HEAD
  version = "2.92.0";
=======
  version = "2.47.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-acOTuvs9AFDGdmj4dwTAabhO31MAJgYOVZghlPQiXT4=";
  };

  vendorHash = "sha256-r1xJka1ISahaHJOkFwjn/Nrf2EU0iGVosz8PZnH31TE=";
=======
    hash = "sha256-GBrdYlWvtlz/A/5Tn58EPYBL3X73D44GzbN1OrzwU8U=";
  };

  vendorHash = "sha256-FIl30sKmdcXayK8KWGFl+N+lYExl4ibKZ2tcvelw8zo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X github.com/supabase/gotrue/internal/utilities.Version=${version}"
=======
    "-X=github.com/netlify/gotrue/internal/utilities.Version=${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
