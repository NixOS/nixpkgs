{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wit-bindgen";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wit-bindgen";
    rev = "wit-bindgen-cli-${version}";
    hash = "sha256-ghWwFjpIOTM6//WQ8WySLzKzy2UlaahUjIxxwYUTQWo=";
  };

  cargoHash = "sha256-Ch/S0/ON2HVEGHJ7jDE9k5q9+/2ANtt8uGv3ze60I6M=";

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
    mainProgram = "wit-bindgen";
  };
}
