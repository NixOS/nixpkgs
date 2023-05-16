<<<<<<< HEAD
{ lib
, fetchFromGitHub
, rustPlatform
, testers
, nix-update-script
, biscuit-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "biscuit-cli";
  version = "0.4.0";
=======
{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "biscuit-cli";
  version = "0.2.0-next-pre20230103";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "biscuit-auth";
    repo = "biscuit-cli";
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-Fd5wBvQe7S/UZ42FMlU+f9qTwcLIMnQrCWVRoHxOx64=";
  };

  cargoHash = "sha256-SHRqdKRAHkWK/pEVFYo3d+r761K4j9BkTg2angQOubk=";

  # Version option does not report the correct version
  # https://github.com/biscuit-auth/biscuit-cli/issues/44
  patches = [ ./version-0.4.0.patch ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = biscuit-cli;
      command = "biscuit --version";
    };
  };

  meta = with lib; {
    description = "CLI to generate and inspect biscuit tokens";
    homepage = "https://www.biscuitsec.org/";
    maintainers = with maintainers; [ shlevy gaelreyrol ];
    license = licenses.bsd3;
    mainProgram = "biscuit";
=======
    rev = "0ecf1ec4c98a90b1bf3614558a029b47c57288df";
    sha256 = "sha256-ADJWqx70IwuvCBeK9rb9WBIsD+oQROQSduSQ8Bu8mfk=";
  };

  cargoLock = {
    outputHashes."biscuit-auth-3.0.0-alpha4" = "sha256-4SzOupoD33D0KHZyVLriGzUHy9XXnWK1pbgqOjJH4PI=";
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "CLI to generate and inspect biscuit tokens";
    homepage = "https://www.biscuitsec.org/";
    maintainers = [ lib.maintainers.shlevy ];
    license = lib.licenses.bsd3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
