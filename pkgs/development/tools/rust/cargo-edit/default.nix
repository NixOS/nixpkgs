{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zlib
, stdenv
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U3B/Tb7q61R5jmBni1QKqqul2JJgjtmh3st04apu0xE=";
  };

  cargoSha256 = "sha256-e8ICBRI6kNfItu3CxxbIY+56/2ho0Rnn1B3w/WJX+KM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl zlib ] ++ lib.optionals stdenv.isDarwin [
    libiconv
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
