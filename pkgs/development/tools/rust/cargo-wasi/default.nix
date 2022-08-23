{ stdenv
, lib
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wasi";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = version;
    sha256 = "sha256-jugq7A3L+5+YUSyp9WWKBd4BA2pcXKd4CMVg5OVMcEA=";
  };

  cargoSha256 = "sha256-L4vRLYm1WaCmA4bGyY7D0yxXuqxGSHMMD/wlY8+MgPk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  cargoPatches = [
    ./0001-Add-Cargo.lock.patch
  ];

  # Checks need to be disabled here because the current test suite makes assumptions
  # about the surrounding environment that aren't Nix friendly. See these lines for specifics:
  # https://github.com/bytecodealliance/cargo-wasi/blob/0.1.26/tests/tests/support.rs#L13-L18
  doCheck = false;

  meta = with lib; {
    description = "A lightweight Cargo subcommand to build code for the wasm32-wasi target";
    homepage = "https://bytecodealliance.github.io/cargo-wasi";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
