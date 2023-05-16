<<<<<<< HEAD
{ lib
, fetchFromGitHub
, nixosTests
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.3";
=======
{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5Vd8fD0nB2POtxDFNVtkJfVEe+O8tjnwlwYosDJjIDA=";
  };

  cargoHash = "sha256-TF4rL7KXsbfYiEOfkKRyr3PCvyocq6tg90OZURZh8f8=";

  passthru = rec {
=======
    hash = "sha256-YCIXpCNKqdCSvq7CSPSwoPc2gpCnnda8S7I4FzpezMc=";
  };

  cargoHash = "sha256-l6gMz/iJeLl+RLjOiR9U1m6V/rK+RWM84bQiz4jCFtY=";

  passthru = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      buildAndTestSubdir = "test_client";

<<<<<<< HEAD
      cargoHash = "sha256-ES0LBKirOUqXOtA9O2KouA+NWisIMoe8XhmnTC8w1cg=";
    };
    tests = {
      inherit (nixosTests.nextcloud) with-postgresql-and-redis26;
      inherit test_client;
=======
      cargoHash = "sha256-4jQvlxU3S3twTpiLab8BXC6ZSPSWN6ftK3GzfKnjHSE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  meta = with lib; {
    description = "Update notifications for nextcloud clients";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ajs124 ];
  };
}
