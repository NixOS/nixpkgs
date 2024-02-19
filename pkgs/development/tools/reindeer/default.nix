{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, libiconv
, darwin
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "reindeer";
  version = "unstable-2024-02-16";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "4968d1edb5daf2f24a22183e3c8ffebf19f898de";
    sha256 = "sha256-Rn8wIwjprpfPjhY4gvCMrP3cz2XSutdCGVi5Wk5lB4w=";
  };

  cargoSha256 = "sha256-ec3CG4wQhtsEKdinqvlr0vAjcNYge2FMn319BmZ77f8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ] ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version" "branch" ];
  };

  meta = with lib; {
    description = "Reindeer is a tool which takes Rust Cargo dependencies and generates Buck build rules";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}

