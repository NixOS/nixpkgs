{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wit-bindgen";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wit-bindgen";
    rev = "wit-bindgen-cli-${version}";
<<<<<<< HEAD
    hash = "sha256-ghWwFjpIOTM6//WQ8WySLzKzy2UlaahUjIxxwYUTQWo=";
  };

  cargoHash = "sha256-Ch/S0/ON2HVEGHJ7jDE9k5q9+/2ANtt8uGv3ze60I6M=";
=======
    hash = "sha256-OLBuzYAeUaJrn9cUqw6nStE468TqTUXeUnfkdMO0D3w=";
  };

  cargoHash = "sha256-blaSgQZweDmkiU0Tck9qmIgpQGDZhgxb1+hs6a4D6Qg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Some tests fail because they need network access to install the `wasm32-unknown-unknown` target.
  # However, GitHub Actions ensures a proper build.
  # See also:
  #   https://github.com/bytecodealliance/wit-bindgen/actions
  #   https://github.com/bytecodealliance/wit-bindgen/blob/main/.github/workflows/main.yml
  doCheck = false;

  meta = with lib; {
    description = "A language binding generator for WebAssembly interface types";
    homepage = "https://github.com/bytecodealliance/wit-bindgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
<<<<<<< HEAD
    mainProgram = "wit-bindgen";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
