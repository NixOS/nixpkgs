{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zlib
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6hiRxVxm9GGss4rLctYiA5ukkyd6V9N47RJ0c/VhqTY=";
  };

  cargoSha256 = "sha256-+JKBmqtDxi30T5Lw5YOn47gSW7p5fecOxZ8i9smDz/s=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl zlib ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    changelog = "https://github.com/killercup/cargo-edit/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne figsoda gerschtli jb55 killercup ];
  };
}
