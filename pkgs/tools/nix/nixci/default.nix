{ lib, stdenv
, rustPlatform
, fetchCrate
, libiconv
, openssl
, pkg-config
, Security
, devour-flake
}:

rustPlatform.buildRustPackage rec {
  pname = "nixci";
  version = "0.1.3";

  src = fetchCrate {
    inherit version;
    pname = "nixci";
    hash = "sha256-sM/1G1mf+msWbG4CX/pZNt4FmSKR2hWXdcq5h7W1AM0=";
  };

  cargoHash = "sha256-PKBNQKuWV4PE7iSKr+LugayroFjDBT4/vyyjJiw/E+I=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libiconv openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  # The rust program expects an environment (at build time) that points to the
  # devour-flake executable.
  DEVOUR_FLAKE = lib.getExe devour-flake;

  meta = with lib; {
    description = "Define and build CI for Nix projects anywhere";
    homepage = "https://github.com/srid/nixci";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ srid ];
    mainProgram = "nixci";
  };
}
