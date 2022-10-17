{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "tokio-console";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "console";
    rev = "tokio-console-v${version}";
    sha256 = "sha256-v9BxfBLRJug/1AgvDV7P5AOXwZfCu1mNgJjhbipoZNg=";
  };

  cargoSha256 = "sha256-584EC9x7tJE3pHqgQVh6LWKuCgLXuBBEnaPvo1A8RIs=";

  nativeBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "A debugger for asynchronous Rust code";
    homepage = "https://github.com/tokio-rs/console";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ max-niederman ];
  };
}

