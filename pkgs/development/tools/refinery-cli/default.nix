{ fetchCrate, lib, openssl, pkg-config, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
  version = "0.8.5";

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
    sha256 = "sha256-I9YjMsl70eiws4ea0P9oqOsNzN+gfO5Jwr7VlFCltq8=";
  };

  cargoSha256 = "sha256-Ehofdr6UNtOwRT0QVFaXDrWFRPqdF9eA8eL/hRwIJUM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    homepage = "https://github.com/rust-db/refinery";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
