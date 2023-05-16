{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "function-runner";
<<<<<<< HEAD
  version = "3.6.0";
=======
  version = "3.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-z03+3x1xGYSa+WVEuHBgUQ9NdqG3rCziNYcwTjWBNV8=";
  };

  cargoHash = "sha256-4sgf7WfaX7jnV8YynZNLi/N8MfkuAc4tk/8eiKEyyxI=";
=======
    sha256 = "sha256-bks73G9oZgZpkSbrRWD34+UcFOMkJJa4qkJIQxcx/Ao=";
  };

  cargoHash = "sha256-V0lr1gqn8w4MrHQO5UVxUl+OdK/ODutAr+nMYHc+4hQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A CLI tool which allows you to run Wasm Functions intended for the Shopify Functions infrastructure";
    homepage = "https://github.com/Shopify/function-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ nintron ];
  };
}
