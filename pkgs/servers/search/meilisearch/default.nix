{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
<<<<<<< HEAD
, nixosTests
, nix-update-script
}:

let version = "1.3.1";
=======
, DiskArbitration
, Foundation
, nixosTests
}:

let version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-jttT4qChoqwTnjjoW0Zc15ZieZN7KD1Us64Tk0eDG3Y=";
=======
    hash = "sha256-mwrWHrndcLwdXJo+UISJdPxZFDgtZh9jEquz7jIHGP0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoBuildFlags = [
    "--package=meilisearch"
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "actix-web-static-files-3.0.5" = "sha256-2BN0RzLhdykvN3ceRLkaKwSZtel2DBqZ+uz4Qut+nII=";
<<<<<<< HEAD
      "heed-0.12.7" = "sha256-mthHMaTqmNae8gpe4ZnozABKBrgFQdn9KWCvIzJJ+u4=";
=======
      "heed-0.12.5" = "sha256-atkKiK8rzqji47tJvUzbIXMw8U1uddHkHakPuEUvmFg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      "lmdb-rkv-sys-0.15.1" = "sha256-zLHTprwF7aa+2jaD7dGYmOZpJYFijMTb4I3ODflNUII=";
      "nelson-0.1.0" = "sha256-eF672quU576wmZSisk7oDR7QiDafuKlSg0BTQkXnzqY=";
    };
  };

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
<<<<<<< HEAD
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      meilisearch = nixosTests.meilisearch;
    };
=======
    DiskArbitration
    Foundation
  ];

  passthru.tests = {
    meilisearch = nixosTests.meilisearch;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Tests will try to compile with mini-dashboard features which downloads something from the internet.
  doCheck = false;

  meta = with lib; {
    description = "Powerful, fast, and an easy to use search engine";
    homepage = "https://docs.meilisearch.com/";
    changelog = "https://github.com/meilisearch/meilisearch/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
<<<<<<< HEAD
    platforms = [ "aarch64-linux" "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];
=======
    platforms = [ "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
