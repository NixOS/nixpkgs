{ lib
, stdenv
, fetchFromGitHub
, openssl
, pkg-config
, libiconv
, darwin
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "gitrs";
  version = "v0.3.6";

  src = fetchFromGitHub {
    owner = "mccurdyc";
    repo = pname;
    rev = version;
    hash = "sha256-+43XJroPNWmdUC6FDL84rZWrJm5fzuUXfpDkAMyVQQg=";
  };

  buildInputs = [ openssl.dev ]
    ++ lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # https://floxdev.com/blog/nixpkgs-contribution
  # Nix recommends using SRI hashes, which are self-descriptive hashes, i.e. hashes that tell you which format they are in. You can use the nix hash to-sri $HASH --type sha256 to transform a sha256 hash to an SRI hash. You'll see that the result is prefixed with `sha256-`

  cargoHash = "sha256-2TXm1JTs0Xkid91A5tdi6Kokm0K1NOPmlocwFXv48uw=";

  nativeBuildInputs = [
    pkg-config # for openssl
  ];

  meta = with lib; {
    description = "A simple, opinionated, tool, written in Rust, for declaratively managing Git repos on your machine";
    homepage = "https://github.com/mccurdyc/gitrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mccurdyc ];
    mainProgram = "gitrs";
  };
}
