{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon";
<<<<<<< HEAD
  version = "2.12.1";
=======
  version = "2.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-oD60D98mPQV454uld+g6FVKAxpyjwrfMAVfQcVPp9Fg=";
  };

  cargoHash = "sha256-lX1IXVGVCe/7jbkjIu+ammWi0BgE+r1tpsZaqz4WLPY=";
=======
    hash = "sha256-3LoqG7t2InDBrfOk0vve/6C5Vjifq5L+Tt8ulMGuASg=";
  };

  cargoHash = "sha256-k41hF7qhT9Y7IBp7rzpRP9pTIf1ZQsEyslaHmss+NhE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "Background rust code checker";
    homepage = "https://github.com/Canop/bacon";
    changelog = "https://github.com/Canop/bacon/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
