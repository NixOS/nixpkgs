{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "subxt";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "subxt";
    rev = "v${version}";
    hash = "sha256-ZTBWGNbCwe6GyGXk/8QBGLiAp4ZO7VZuJvtZicJsvgA=";
  };

  cargoHash = "sha256-FBtwmItzT5uFsKCx36POrYk5qDmlX9Nkx0E3hx17HqI=";

  # Only build the command line client
  cargoBuildFlags = [ "--bin" "subxt" ];

  # Needed by wabt-sys
  nativeBuildInputs = [ cmake ];

  # Requires a running substrate node
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/paritytech/subxt";
    description = "Submit transactions to a substrate node via RPC.";
    license = with licenses; [ gpl3Plus asl20 ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
