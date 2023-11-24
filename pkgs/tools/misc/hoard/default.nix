{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "hoard";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Hyde46";
    repo = "hoard";
    rev = "v${version}";
    hash = "sha256-c9iSbxkHwLOeATkO7kzTyLD0VAwZUzCvw5c4FyuR5/E=";
  };

  cargoHash = "sha256-4EeeD1ySR4M1i2aaKJP/BNSn+t1l8ingiv2ZImFFn1A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "CLI command organizer written in rust";
    homepage = "https://github.com/hyde46/hoard";
    changelog = "https://github.com/Hyde46/hoard/blob/${src.rev}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ builditluc figsoda ];
    mainProgram = "hoard";
  };
}
